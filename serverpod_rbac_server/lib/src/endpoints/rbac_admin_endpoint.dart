import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../rbac_service.dart';
import '../session_rbac_extension.dart';

/// Endpoint for managing RBAC roles, permissions, and assignments.
class RbacAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<void> _checkAdminAccess(Session session) async {
    final isSuper = await session.rbac.isSuperuser();
    if (isSuper) return;

    final canManage = await session.rbac.hasPermission('rbac.manage');
    if (!canManage) {
      throw RbacException(
        message:
            'Administrative permission required: "rbac.manage" or superuser',
        reason: RbacExceptionReason.permissionDenied,
        requiredPermission: 'rbac.manage',
        userIdentifier: session.authenticated?.userIdentifier,
      );
    }
  }

  // ==========================================
  // PERMISSIONS
  // ==========================================

  /// Creates a new permission.
  Future<RbacPermission> createPermission(
    Session session, {
    required String resource,
    required String codename,
    required String name,
    String? description,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.createPermission(
      session,
      resource: resource,
      codename: codename,
      name: name,
      description: description,
    );
  }

  /// Lists all registered permissions.
  Future<List<RbacPermission>> listPermissions(
    Session session, {
    String? resource,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.listPermissions(session, resource: resource);
  }

  /// Deletes a permission by ID.
  Future<void> deletePermission(
    Session session,
    int permissionId,
  ) async {
    await _checkAdminAccess(session);
    await RbacService.instance.deletePermission(session, permissionId);
  }

  // ==========================================
  // ROLES
  // ==========================================

  /// Creates a new role.
  Future<RbacRole> createRole(
    Session session, {
    required String name,
    String? description,
    bool? isSuperuser,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.createRole(
      session,
      name: name,
      description: description,
      isSuperuser: isSuperuser ?? false,
    );
  }

  /// Lists all roles.
  Future<List<RbacRole>> listRoles(Session session) async {
    await _checkAdminAccess(session);
    return RbacService.instance.listRoles(session);
  }

  /// Deletes a role by name.
  Future<void> deleteRole(Session session, String name) async {
    await _checkAdminAccess(session);
    await RbacService.instance.deleteRole(session, name);
  }

  // ==========================================
  // ROLE-PERMISSION ASSIGNMENTS
  // ==========================================

  /// Assigns permissions to a role.
  Future<void> assignPermissionsToRole(
    Session session, {
    required String roleName,
    required List<String> permissions,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.assignPermissionsToRole(
      session,
      roleName: roleName,
      permissions: permissions,
    );
  }

  /// Removes permissions from a role.
  Future<void> removePermissionsFromRole(
    Session session, {
    required String roleName,
    required List<String> permissions,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.removePermissionsFromRole(
      session,
      roleName: roleName,
      permissions: permissions,
    );
  }

  /// Gets all permissions assigned to a role.
  Future<List<RbacPermission>> getRolePermissions(
    Session session,
    String roleName,
  ) async {
    await _checkAdminAccess(session);
    return RbacService.instance.getRolePermissions(session, roleName);
  }

  // ==========================================
  // USER-ROLE ASSIGNMENTS
  // ==========================================

  /// Assigns a role to a user.
  Future<void> assignRoleToUser(
    Session session, {
    required String userIdentifier,
    required String roleName,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.assignRoleToUser(
      session,
      userIdentifier: userIdentifier,
      roleName: roleName,
    );
  }

  /// Removes a role from a user.
  Future<void> removeRoleFromUser(
    Session session, {
    required String userIdentifier,
    required String roleName,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.removeRoleFromUser(
      session,
      userIdentifier: userIdentifier,
      roleName: roleName,
    );
  }

  /// Gets all roles assigned to a user.
  Future<List<RbacRole>> getUserRoles(
    Session session,
    String userIdentifier,
  ) async {
    await _checkAdminAccess(session);
    return RbacService.instance.getUserRoles(
      session,
      userIdentifier,
    );
  }

  // ==========================================
  // USER-PERMISSION DIRECT ASSIGNMENTS
  // ==========================================

  /// Grants a permission directly to a user.
  Future<void> grantPermissionToUser(
    Session session, {
    required String userIdentifier,
    required String permission,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.grantPermissionToUser(
      session,
      userIdentifier: userIdentifier,
      permission: permission,
    );
  }

  /// Revokes a permission directly from a user.
  Future<void> revokePermissionFromUser(
    Session session, {
    required String userIdentifier,
    required String permission,
    bool? explicitDeny,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.revokePermissionFromUser(
      session,
      userIdentifier: userIdentifier,
      permission: permission,
      explicitDeny: explicitDeny ?? false,
    );
  }

  /// Inspects full permissions info for any user.
  Future<RbacUserPermissionsInfo> getUserPermissionsInfo(
    Session session, {
    required String userIdentifier,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.getUserPermissionsInfo(
      session,
      userIdentifier,
    );
  }
}
