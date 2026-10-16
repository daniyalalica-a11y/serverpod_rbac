import 'package:serverpod/serverpod.dart';
import 'generated/protocol.dart';
import 'rbac_audit.dart';
import 'rbac_cache.dart';
import 'rbac_config.dart';

/// Callback to customize superuser determination.
typedef SuperuserResolver =
    Future<bool> Function(Session session, String userIdentifier);

/// Primary service for Role-Based Access Control (RBAC).
class RbacService {
  RbacService._();

  /// Singleton instance of the RBAC service.
  static final RbacService instance = RbacService._();

  /// Central configuration for the RBAC service.
  RbacConfig config = RbacConfig();

  /// Updates or reconfigures the RBAC service settings.
  void configure(RbacConfig newConfig) {
    config = newConfig;
  }

  /// Cache manager for RBAC.
  final RbacCache cache = RbacCache();

  /// Audit logger for RBAC.
  final RbacAuditService audit = RbacAuditService();

  /// Optional custom resolver for superuser status.
  SuperuserResolver? customSuperuserResolver;

  // ==========================================
  // PERMISSION PARSING & NORMALIZATION
  // ==========================================

  /// Normalizes a permission string into (resource, codename).
  ///
  /// Supports:
  /// - Full format: `'resource.codename'` (e.g. `'article.change'`)
  /// - Resource + codename passed explicitly
  static (String resource, String codename) parsePermission(
    String permission, {
    String defaultResource = 'global',
  }) {
    final dotIndex = permission.indexOf('.');
    if (dotIndex != -1) {
      final resource = permission.substring(0, dotIndex).trim();
      final codename = permission.substring(dotIndex + 1).trim();
      return (resource, codename);
    }
    return (defaultResource, permission.trim());
  }

  /// Formats resource and codename into canonical string `'resource.codename'`.
  static String formatPermissionKey(String resource, String codename) =>
      '$resource.$codename';

  // ==========================================
  // USER IDENTIFIER EXTRACTION
  // ==========================================

  /// Extracts user identifier from the current session or throws [RbacException].
  String requireUserIdentifier(Session session, [String? explicitIdentifier]) {
    final identifier =
        explicitIdentifier ?? session.authenticated?.userIdentifier;
    if (identifier == null || identifier.isEmpty) {
      throw RbacException(
        message: 'Authentication required to perform RBAC check',
        reason: RbacExceptionReason.notAuthenticated,
      );
    }
    return identifier;
  }

  /// Resolves user identifier from current session, returning null if unauthenticated.
  String? getUserIdentifier(Session session, [String? explicitIdentifier]) {
    return explicitIdentifier ?? session.authenticated?.userIdentifier;
  }

  // ==========================================
  // SUPERUSER CHECK
  // ==========================================

  /// Determines whether a user has superuser privileges.
  Future<bool> isSuperuser(
    Session session, {
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    // 1. Check Serverpod native Scope.admin
    if (session.authenticated?.userIdentifier == uid &&
        session.authenticated?.scopes.contains(Scope.admin) == true) {
      return true;
    }

    // 2. Check custom resolver if configured
    if (customSuperuserResolver != null) {
      final isSuper = await customSuperuserResolver!(session, uid);
      if (isSuper) return true;
    }

    // 3. Check user roles in database
    final roles = await getUserRoles(session, uid);
    return roles.any((r) => r.isSuperuser);
  }

  // ==========================================
  // PERMISSION RESOLUTION & EVALUATION
  // ==========================================

  /// Resolves the comprehensive permissions information for a user.
  Future<RbacUserPermissionsInfo> getUserPermissionsInfo(
    Session session,
    String userIdentifier, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await cache.getUserPermissionsInfo(
        session,
        userIdentifier,
      );
      if (cached != null) return cached;
    }

    final isSuper = await isSuperuser(session, userIdentifier: userIdentifier);

    // 1. Fetch assigned roles.
    final userRoles = await RbacUserRole.db.find(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
    );

    final roleIds = userRoles.map((ur) => ur.roleId).toSet();
    final roleNames = <String>[];
    final resolvedPermissions = <String>{};

    if (roleIds.isNotEmpty) {
      final roles = await RbacRole.db.find(
        session,
        where: (t) => t.id.inSet(roleIds),
      );
      for (final r in roles) {
        roleNames.add(r.name);
      }

      // Fetch role permissions
      final rolePermissions = await RbacRolePermission.db.find(
        session,
        where: (t) => t.roleId.inSet(roleIds),
      );
      final permIds = rolePermissions.map((rp) => rp.permissionId).toSet();

      if (permIds.isNotEmpty) {
        final perms = await RbacPermission.db.find(
          session,
          where: (t) => t.id.inSet(permIds),
        );
        for (final p in perms) {
          resolvedPermissions.add(formatPermissionKey(p.resource, p.codename));
        }
      }
    }

    // 2. Fetch direct user permissions (GRANT or REVOKE overrides)
    final userPerms = await RbacUserPermission.db.find(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
    );

    if (userPerms.isNotEmpty) {
      final directPermIds = userPerms.map((up) => up.permissionId).toSet();
      final perms = await RbacPermission.db.find(
        session,
        where: (t) => t.id.inSet(directPermIds),
      );
      final permMap = {for (final p in perms) p.id: p};

      for (final up in userPerms) {
        final p = permMap[up.permissionId];
        if (p == null) continue;
        final key = formatPermissionKey(p.resource, p.codename);
        if (up.isGranted) {
          resolvedPermissions.add(key);
        } else {
          resolvedPermissions.remove(key); // Explicit deny/revocation
        }
      }
    }

    final info = RbacUserPermissionsInfo(
      userIdentifier: userIdentifier,
      isSuperuser: isSuper,
      roles: roleNames,
      permissions: resolvedPermissions.toList(),
    );

    await cache.putUserPermissionsInfo(
      session,
      userIdentifier,
      info,
    );

    return info;
  }

  /// Checks if the user has a specific permission.
  ///
  /// [permission] can be in `'resource.codename'` format or just `'codename'`.
  Future<bool> hasPermission(
    Session session,
    String permission, {
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) {
      await audit.log(
        session,
        action: 'check_permission',
        permissionCodename: permission,
        allowed: false,
        details: 'User is not authenticated',
      );
      return false;
    }

    final info = await getUserPermissionsInfo(session, uid);
    if (info.isSuperuser && config.superusersBypassAll) {
      await audit.log(
        session,
        userIdentifier: uid,
        action: 'check_permission',
        permissionCodename: permission,
        allowed: true,
        details: 'Granted by superuser privilege',
      );
      return true;
    }

    final (resource, codename) = parsePermission(
      permission,
      defaultResource: config.defaultResource,
    );
    final hasPerm = _hasPermissionInInfo(info, permission);

    await audit.log(
      session,
      userIdentifier: uid,
      action: 'check_permission',
      resource: resource,
      permissionCodename: codename,
      allowed: hasPerm,
      details: hasPerm ? 'Permission granted' : 'Permission denied',
    );

    return hasPerm;
  }

  /// Checks if the user has ALL of the specified permissions (AND logic).
  Future<bool> hasAllPermissions(
    Session session,
    List<String> permissions, {
    String? userIdentifier,
  }) async {
    return _hasCompositePermissions(
      session,
      permissions,
      userIdentifier: userIdentifier,
      requireAll: true,
    );
  }

  /// Checks if the user has AT LEAST ONE of the specified permissions (OR logic).
  Future<bool> hasAnyPermission(
    Session session,
    List<String> permissions, {
    String? userIdentifier,
  }) async {
    return _hasCompositePermissions(
      session,
      permissions,
      userIdentifier: userIdentifier,
      requireAll: false,
    );
  }

  Future<bool> _hasCompositePermissions(
    Session session,
    List<String> permissions, {
    String? userIdentifier,
    required bool requireAll,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) {
      await audit.log(
        session,
        action: requireAll ? 'check_all_permissions' : 'check_any_permission',
        allowed: false,
        details:
            'User is not authenticated; requested: ${permissions.join(', ')}',
      );
      return false;
    }

    final info = await getUserPermissionsInfo(session, uid);
    final allowed = info.isSuperuser && config.superusersBypassAll
        ? requireAll || permissions.isNotEmpty
        : requireAll
        ? permissions.every(
            (permission) => _hasPermissionInInfo(info, permission),
          )
        : permissions.any(
            (permission) => _hasPermissionInInfo(info, permission),
          );

    await audit.log(
      session,
      userIdentifier: uid,
      action: requireAll ? 'check_all_permissions' : 'check_any_permission',
      allowed: allowed,
      details: 'Requested: ${permissions.join(', ')}',
    );
    return allowed;
  }

  bool _hasPermissionInInfo(RbacUserPermissionsInfo info, String permission) {
    final (resource, codename) = parsePermission(
      permission,
      defaultResource: config.defaultResource,
    );
    final canonicalKey = formatPermissionKey(resource, codename);
    if (permission.contains('.')) {
      return info.permissions.contains(canonicalKey) ||
          info.permissions.contains('$resource.*') ||
          info.permissions.contains('*.*');
    }
    return info.permissions.contains(canonicalKey) ||
        info.permissions.any((p) => p.endsWith('.$codename')) ||
        info.permissions.contains('*.*');
  }

  /// Checks if the user has a specific role.
  Future<bool> hasRole(
    Session session,
    String roleName, {
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    final info = await getUserPermissionsInfo(session, uid);
    if (info.isSuperuser && config.superusersBypassAll) return true;

    final hasRole = info.roles.contains(roleName);
    await audit.log(
      session,
      userIdentifier: uid,
      action: 'check_role',
      roleName: roleName,
      allowed: hasRole,
    );
    return hasRole;
  }

  /// Checks if the user has AT LEAST ONE of the specified roles.
  Future<bool> hasAnyRole(
    Session session,
    List<String> roleNames, {
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    final info = await getUserPermissionsInfo(session, uid);
    final allowed = info.isSuperuser && config.superusersBypassAll
        ? roleNames.isNotEmpty
        : roleNames.any(info.roles.contains);
    await audit.log(
      session,
      userIdentifier: uid,
      action: 'check_any_role',
      allowed: allowed,
      details: 'Requested: ${roleNames.join(', ')}',
    );
    return allowed;
  }

  /// Checks if the user has ALL of the specified roles.
  Future<bool> hasAllRoles(
    Session session,
    List<String> roleNames, {
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    final info = await getUserPermissionsInfo(session, uid);
    final allowed = info.isSuperuser && config.superusersBypassAll
        ? true
        : roleNames.every(info.roles.contains);
    await audit.log(
      session,
      userIdentifier: uid,
      action: 'check_all_roles',
      allowed: allowed,
      details: 'Requested: ${roleNames.join(', ')}',
    );
    return allowed;
  }

  // ==========================================
  // REQUIREMENT ENFORCERS (THROWS ON DENIAL)
  // ==========================================

  /// Enforces that the current session user has [permission].
  ///
  /// Throws [RbacException] if permission is denied or user is unauthenticated.
  Future<void> requirePermission(
    Session session,
    String permission, {
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasPermission(
      session,
      permission,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Permission denied: required "$permission"',
        reason: RbacExceptionReason.permissionDenied,
        requiredPermission: permission,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the current session user has ALL of [permissions].
  Future<void> requireAllPermissions(
    Session session,
    List<String> permissions, {
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasAllPermissions(
      session,
      permissions,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message:
            'Permission denied: required all of [${permissions.join(", ")}]',
        reason: RbacExceptionReason.permissionDenied,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the current session user has AT LEAST ONE of [permissions].
  Future<void> requireAnyPermission(
    Session session,
    List<String> permissions, {
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasAnyPermission(
      session,
      permissions,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message:
            'Permission denied: required any of [${permissions.join(", ")}]',
        reason: RbacExceptionReason.permissionDenied,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the current session user has [roleName].
  Future<void> requireRole(
    Session session,
    String roleName, {
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasRole(
      session,
      roleName,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Role required: "$roleName"',
        reason: RbacExceptionReason.roleDenied,
        requiredRole: roleName,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the user has ALL of the specified roles.
  Future<void> requireAllRoles(
    Session session,
    List<String> roleNames, {
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasAllRoles(
      session,
      roleNames,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Roles required: [${roleNames.join(", ")}]',
        reason: RbacExceptionReason.roleDenied,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that user has any of the specified roles.
  Future<void> requireAnyRole(
    Session session,
    List<String> roleNames, {
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasAnyRole(
      session,
      roleNames,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Role denied: required any of [${roleNames.join(", ")}]',
        reason: RbacExceptionReason.roleDenied,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the user has superuser privileges.
  Future<void> requireSuperuser(
    Session session, {
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final isSuper = await isSuperuser(session, userIdentifier: uid);
    if (!isSuper) {
      throw RbacException(
        message: 'Superuser privilege required',
        reason: RbacExceptionReason.permissionDenied,
        userIdentifier: uid,
      );
    }
  }

  // ==========================================
  // MANAGEMENT: PERMISSIONS
  // ==========================================

  /// Creates or retrieves an existing permission.
  Future<RbacPermission> createPermission(
    Session session, {
    required String resource,
    required String codename,
    required String name,
    String? description,
  }) async {
    final existing = await RbacPermission.db.findFirstRow(
      session,
      where: (t) => t.resource.equals(resource) & t.codename.equals(codename),
    );
    if (existing != null) return existing;

    final perm = RbacPermission(
      resource: resource.trim().toLowerCase(),
      codename: codename.trim().toLowerCase(),
      name: name,
      description: description,
      createdAt: DateTime.now(),
    );

    final inserted = await RbacPermission.db.insertRow(session, perm);
    await cache.invalidateAll(session);
    await audit.log(
      session,
      action: 'create_permission',
      resource: resource,
      permissionCodename: codename,
      allowed: true,
      details: 'Created permission $name',
    );
    return inserted;
  }

  /// Lists all registered permissions.
  Future<List<RbacPermission>> listPermissions(
    Session session, {
    String? resource,
  }) async {
    return RbacPermission.db.find(
      session,
      where: resource != null ? (t) => t.resource.equals(resource) : null,
      orderBy: (t) => t.resource,
    );
  }

  /// Deletes a permission by ID.
  Future<void> deletePermission(Session session, int permissionId) async {
    final perm = await RbacPermission.db.findById(session, permissionId);
    if (perm != null) {
      await RbacPermission.db.deleteRow(session, perm);
      await cache.invalidateAll(session);
      await audit.log(
        session,
        action: 'delete_permission',
        resource: perm.resource,
        permissionCodename: perm.codename,
        allowed: true,
      );
    }
  }

  // ==========================================
  // MANAGEMENT: ROLES
  // ==========================================

  /// Creates a new role.
  Future<RbacRole> createRole(
    Session session, {
    required String name,
    String? description,
    bool isSuperuser = false,
    bool isSystemRole = false,
  }) async {
    final normalizedName = name.trim().toLowerCase();
    final existing = await RbacRole.db.findFirstRow(
      session,
      where: (t) => t.name.equals(normalizedName),
    );
    if (existing != null) return existing;

    final role = RbacRole(
      name: normalizedName,
      description: description,
      isSuperuser: isSuperuser,
      isSystemRole: isSystemRole,
      createdAt: DateTime.now(),
    );

    final inserted = await RbacRole.db.insertRow(session, role);
    await cache.invalidateAll(session);
    await audit.log(
      session,
      action: 'create_role',
      roleName: normalizedName,
      allowed: true,
      details: 'Role created (isSuperuser: $isSuperuser)',
    );
    return inserted;
  }

  /// Retrieves a role by name.
  Future<RbacRole?> getRole(Session session, String name) async {
    return RbacRole.db.findFirstRow(
      session,
      where: (t) => t.name.equals(name.trim().toLowerCase()),
    );
  }

  /// Lists all roles.
  Future<List<RbacRole>> listRoles(Session session) async {
    return RbacRole.db.find(session, orderBy: (t) => t.name);
  }

  /// Deletes a role by name or ID.
  Future<void> deleteRole(Session session, String name) async {
    final role = await getRole(session, name);
    if (role != null) {
      if (role.isSystemRole) {
        throw RbacException(
          message: 'Cannot delete system role "${role.name}"',
          reason: RbacExceptionReason.roleDenied,
        );
      }
      await RbacRole.db.deleteRow(session, role);
      await cache.invalidateAll(session);
      await audit.log(
        session,
        action: 'delete_role',
        roleName: role.name,
        allowed: true,
      );
    }
  }

  // ==========================================
  // MANAGEMENT: ROLE PERMISSIONS
  // ==========================================

  /// Assigns one or more permissions to a role.
  Future<void> assignPermissionsToRole(
    Session session, {
    required String roleName,
    required List<String> permissions,
  }) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) {
      throw RbacException(
        message: 'Role "$roleName" not found',
        reason: RbacExceptionReason.roleNotFound,
        requiredRole: roleName,
      );
    }

    final rowsToInsert = <RbacRolePermission>[];
    final assignedPermissionIds = <int>{};
    for (final permStr in permissions) {
      final (res, code) = parsePermission(permStr);
      final perm = await RbacPermission.db.findFirstRow(
        session,
        where: (t) => t.resource.equals(res) & t.codename.equals(code),
      );
      if (perm == null || perm.id == null) continue;

      if (!assignedPermissionIds.add(perm.id!)) continue;

      final existing = await RbacRolePermission.db.findFirstRow(
        session,
        where: (t) =>
            t.roleId.equals(role.id!) & t.permissionId.equals(perm.id!),
      );
      if (existing == null) {
        rowsToInsert.add(
          RbacRolePermission(
            roleId: role.id!,
            permissionId: perm.id!,
            createdAt: DateTime.now(),
          ),
        );
      }
    }

    if (rowsToInsert.isNotEmpty) {
      await RbacRolePermission.db.insert(
        session,
        rowsToInsert,
        noReturn: true,
      );
    }

    await cache.invalidateAll(session);
    await audit.log(
      session,
      action: 'assign_permissions_to_role',
      roleName: roleName,
      allowed: true,
      details: 'Assigned ${permissions.length} permissions',
    );
  }

  /// Removes permissions from a role.
  Future<void> removePermissionsFromRole(
    Session session, {
    required String roleName,
    required List<String> permissions,
  }) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) return;

    for (final permStr in permissions) {
      final (res, code) = parsePermission(permStr);
      final perm = await RbacPermission.db.findFirstRow(
        session,
        where: (t) => t.resource.equals(res) & t.codename.equals(code),
      );
      if (perm == null || perm.id == null) continue;

      final existing = await RbacRolePermission.db.findFirstRow(
        session,
        where: (t) =>
            t.roleId.equals(role.id!) & t.permissionId.equals(perm.id!),
      );
      if (existing != null) {
        await RbacRolePermission.db.deleteRow(session, existing);
      }
    }

    await cache.invalidateAll(session);
    await audit.log(
      session,
      action: 'remove_permissions_from_role',
      roleName: roleName,
      allowed: true,
      details: 'Removed ${permissions.length} permissions',
    );
  }

  /// Gets all permissions assigned to a role.
  Future<List<RbacPermission>> getRolePermissions(
    Session session,
    String roleName,
  ) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) return [];

    final rolePerms = await RbacRolePermission.db.find(
      session,
      where: (t) => t.roleId.equals(role.id!),
    );
    final permIds = rolePerms.map((rp) => rp.permissionId).toSet();
    if (permIds.isEmpty) return [];

    return RbacPermission.db.find(
      session,
      where: (t) => t.id.inSet(permIds),
    );
  }

  // ==========================================
  // MANAGEMENT: USER ROLES
  // ==========================================

  /// Assigns a role to a user.
  Future<void> assignRoleToUser(
    Session session, {
    required String userIdentifier,
    required String roleName,
  }) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) {
      throw RbacException(
        message: 'Role "$roleName" not found',
        reason: RbacExceptionReason.roleNotFound,
        requiredRole: roleName,
      );
    }

    final existing = await RbacUserRole.db.findFirstRow(
      session,
      where: (t) =>
          t.userIdentifier.equals(userIdentifier) & t.roleId.equals(role.id!),
    );

    if (existing == null) {
      await RbacUserRole.db.insertRow(
        session,
        RbacUserRole(
          userIdentifier: userIdentifier,
          roleId: role.id!,
          createdAt: DateTime.now(),
        ),
      );
    }

    await cache.invalidateUser(session, userIdentifier);
    await audit.log(
      session,
      userIdentifier: userIdentifier,
      action: 'assign_role_to_user',
      roleName: roleName,
      allowed: true,
    );
  }

  /// Removes a role from a user.
  Future<void> removeRoleFromUser(
    Session session, {
    required String userIdentifier,
    required String roleName,
  }) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) return;

    final existing = await RbacUserRole.db.findFirstRow(
      session,
      where: (t) =>
          t.userIdentifier.equals(userIdentifier) & t.roleId.equals(role.id!),
    );

    if (existing != null) {
      await RbacUserRole.db.deleteRow(session, existing);
    }

    await cache.invalidateUser(session, userIdentifier);
    await audit.log(
      session,
      userIdentifier: userIdentifier,
      action: 'remove_role_from_user',
      roleName: roleName,
      allowed: true,
    );
  }

  /// Gets all roles assigned to a user.
  Future<List<RbacRole>> getUserRoles(
    Session session,
    String userIdentifier,
  ) async {
    final userRoles = await RbacUserRole.db.find(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
    );
    final roleIds = userRoles.map((ur) => ur.roleId).toSet();
    if (roleIds.isEmpty) return [];

    return RbacRole.db.find(
      session,
      where: (t) => t.id.inSet(roleIds),
    );
  }

  // ==========================================
  // MANAGEMENT: DIRECT USER PERMISSIONS
  // ==========================================

  /// Grants a permission directly to a user (Django-style `user_permissions`).
  Future<void> grantPermissionToUser(
    Session session, {
    required String userIdentifier,
    required String permission,
  }) async {
    final (res, code) = parsePermission(permission);
    final perm = await RbacPermission.db.findFirstRow(
      session,
      where: (t) => t.resource.equals(res) & t.codename.equals(code),
    );
    if (perm == null || perm.id == null) {
      throw RbacException(
        message: 'Permission "$permission" not found',
        reason: RbacExceptionReason.permissionNotFound,
        requiredPermission: permission,
      );
    }

    final existing = await RbacUserPermission.db.findFirstRow(
      session,
      where: (t) =>
          t.userIdentifier.equals(userIdentifier) &
          t.permissionId.equals(perm.id!),
    );

    if (existing == null) {
      await RbacUserPermission.db.insertRow(
        session,
        RbacUserPermission(
          userIdentifier: userIdentifier,
          permissionId: perm.id!,
          isGranted: true,
          createdAt: DateTime.now(),
        ),
      );
    } else if (!existing.isGranted) {
      existing.isGranted = true;
      await RbacUserPermission.db.updateRow(session, existing);
    }

    await cache.invalidateUser(session, userIdentifier);
    await audit.log(
      session,
      userIdentifier: userIdentifier,
      action: 'grant_user_permission',
      resource: res,
      permissionCodename: code,
      allowed: true,
    );
  }

  /// Revokes (or explicitly denies) a permission for a user.
  Future<void> revokePermissionFromUser(
    Session session, {
    required String userIdentifier,
    required String permission,
    bool explicitDeny = false,
  }) async {
    final (res, code) = parsePermission(permission);
    final perm = await RbacPermission.db.findFirstRow(
      session,
      where: (t) => t.resource.equals(res) & t.codename.equals(code),
    );
    if (perm == null || perm.id == null) return;

    final existing = await RbacUserPermission.db.findFirstRow(
      session,
      where: (t) =>
          t.userIdentifier.equals(userIdentifier) &
          t.permissionId.equals(perm.id!),
    );

    if (existing != null) {
      if (explicitDeny) {
        existing.isGranted = false;
        await RbacUserPermission.db.updateRow(session, existing);
      } else {
        await RbacUserPermission.db.deleteRow(session, existing);
      }
    } else if (explicitDeny) {
      await RbacUserPermission.db.insertRow(
        session,
        RbacUserPermission(
          userIdentifier: userIdentifier,
          permissionId: perm.id!,
          isGranted: false,
          createdAt: DateTime.now(),
        ),
      );
    }

    await cache.invalidateUser(session, userIdentifier);
    await audit.log(
      session,
      userIdentifier: userIdentifier,
      action: 'revoke_user_permission',
      resource: res,
      permissionCodename: code,
      allowed: true,
      details: explicitDeny ? 'Explicit deny override' : 'Direct grant removed',
    );
  }
}
