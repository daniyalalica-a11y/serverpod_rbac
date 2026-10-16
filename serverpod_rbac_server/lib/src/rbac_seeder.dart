import 'package:serverpod/serverpod.dart';

import 'generated/protocol.dart';
import 'rbac_service.dart';

/// Declarative permission definition used by [RbacSeeder].
class RbacSeedPermission {
  /// Creates a permission definition.
  const RbacSeedPermission({
    required this.resource,
    required this.codename,
    required this.name,
    this.description,
  });

  /// Permission resource, such as `article`.
  final String resource;

  /// Permission codename, such as `change`.
  final String codename;

  /// Human-readable permission name.
  final String name;

  /// Optional permission description.
  final String? description;
}

/// Declarative role definition used by [RbacSeeder].
class RbacSeedRole {
  /// Creates a role definition.
  const RbacSeedRole({
    required this.name,
    required this.permissions,
    this.description,
    this.isSuperuser = false,
  });

  /// Stable role name.
  final String name;

  /// Permission keys to assign to this role, in `resource.codename` format.
  final List<String> permissions;

  /// Optional role description.
  final String? description;

  /// Whether this role grants superuser privileges.
  final bool isSuperuser;
}

/// Idempotently creates the RBAC permissions, roles, and role assignments.
///
/// Seeding is additive: existing permissions and role assignments are kept.
/// Run this from a trusted startup/bootstrap session or a deployment task, not
/// from a client-facing endpoint.
class RbacSeeder {
  /// Seeds RBAC definitions and returns after all records are applied.
  static Future<void> seed(
    Session session, {
    required List<RbacSeedPermission> permissions,
    required List<RbacSeedRole> roles,
  }) async {
    final service = RbacService.instance;

    final permissionsByKey = <String, RbacSeedPermission>{};
    for (final permission in permissions) {
      final key = _normalizePermission(
        '${permission.resource}.${permission.codename}',
        service.config.defaultResource,
      );
      permissionsByKey.putIfAbsent(key, () => permission);
    }

    final roleNames = <String>{};
    for (final role in roles) {
      roleNames.add(role.name.trim().toLowerCase());
    }

    final missingPermissions = {
      for (final role in roles)
        for (final permission in role.permissions)
          if (!permissionsByKey.containsKey(
            _normalizePermission(permission, service.config.defaultResource),
          ))
            permission,
    };
    if (missingPermissions.isNotEmpty) {
      throw ArgumentError(
        'Roles reference permissions missing from the seed: '
        '${missingPermissions.join(', ')}',
      );
    }

    final permissionRows = [
      for (final entry in permissionsByKey.entries)
        RbacPermission(
          resource: _normalizePart(entry.value.resource),
          codename: _normalizePart(entry.value.codename),
          name: entry.value.name,
          description: entry.value.description,
        ),
    ];
    final insertedPermissions = permissionRows.isEmpty
        ? <RbacPermission>[]
        : await RbacPermission.db.insert(
            session,
            permissionRows,
            ignoreConflicts: true,
          );

    final roleDefinitionsByName = <String, RbacSeedRole>{};
    for (final role in roles) {
      roleDefinitionsByName.putIfAbsent(
        role.name.trim().toLowerCase(),
        () => role,
      );
    }

    final roleRows = [
      for (final entry in roleDefinitionsByName.entries)
        RbacRole(
          name: entry.key,
          description: entry.value.description,
          isSuperuser: entry.value.isSuperuser,
          isSystemRole: false,
        ),
    ];
    final insertedRoles = roleRows.isEmpty
        ? <RbacRole>[]
        : await RbacRole.db.insert(
            session,
            roleRows,
            ignoreConflicts: true,
          );

    final permissionResources = permissionRows
        .map((permission) => permission.resource)
        .toSet();
    final resolvedPermissions = permissionResources.isEmpty
        ? <RbacPermission>[]
        : await RbacPermission.db.find(
            session,
            where: (t) => t.resource.inSet(permissionResources),
          );
    final permissionIdsByKey = <String, int>{
      for (final permission in resolvedPermissions)
        '${permission.resource}.${permission.codename}': permission.id!,
    };

    final resolvedRoles = roleNames.isEmpty
        ? <RbacRole>[]
        : await RbacRole.db.find(
            session,
            where: (t) => t.name.inSet(roleNames),
          );
    final roleIdsByName = <String, int>{
      for (final role in resolvedRoles) role.name: role.id!,
    };

    final rolePermissionRows = <RbacRolePermission>[];
    final rolePermissionKeys = <(int, int)>{};
    for (final role in roles) {
      final roleName = role.name.trim().toLowerCase();
      final roleId = roleIdsByName[roleName];
      if (roleId == null) {
        throw StateError('Failed to resolve seeded role "$roleName".');
      }

      for (final permission in role.permissions) {
        final permissionKey = _normalizePermission(
          permission,
          service.config.defaultResource,
        );
        final permissionId = permissionIdsByKey[permissionKey];
        if (permissionId == null) {
          throw StateError(
            'Failed to resolve seeded permission "$permission".',
          );
        }

        if (rolePermissionKeys.add((roleId, permissionId))) {
          rolePermissionRows.add(
            RbacRolePermission(
              roleId: roleId,
              permissionId: permissionId,
            ),
          );
        }
      }
    }

    if (rolePermissionRows.isNotEmpty) {
      await RbacRolePermission.db.insert(
        session,
        rolePermissionRows,
        ignoreConflicts: true,
        noReturn: true,
      );
    }

    final insertedPermissionKeys = insertedPermissions
        .map((permission) => '${permission.resource}.${permission.codename}')
        .toSet();
    final insertedRoleNames = insertedRoles.map((role) => role.name).toSet();
    final auditEntries = <RbacAuditLog>[];
    for (final entry in permissionsByKey.entries) {
      if (!insertedPermissionKeys.contains(entry.key)) continue;
      final permission = entry.value;
      auditEntries.add(
        RbacAuditLog(
          action: 'create_permission',
          resource: permission.resource,
          permissionCodename: permission.codename,
          allowed: true,
          details: 'Created permission ${permission.name}',
        ),
      );
    }
    final createdRoleNames = <String>{};
    for (final role in roles) {
      final roleName = role.name.trim().toLowerCase();
      if (insertedRoleNames.contains(roleName) &&
          createdRoleNames.add(roleName)) {
        final definition = roleDefinitionsByName[roleName]!;
        auditEntries.add(
          RbacAuditLog(
            action: 'create_role',
            roleName: roleName,
            allowed: true,
            details: 'Role created (isSuperuser: ${definition.isSuperuser})',
          ),
        );
      }
      auditEntries.add(
        RbacAuditLog(
          action: 'assign_permissions_to_role',
          roleName: role.name,
          allowed: true,
          details: 'Assigned ${role.permissions.length} permissions',
        ),
      );
    }
    await service.audit.logMany(session, auditEntries);

    if (insertedPermissions.isNotEmpty ||
        insertedRoles.isNotEmpty ||
        roles.isNotEmpty) {
      await service.cache.invalidateAll(session);
    }
  }

  static String _normalizePart(String value) => value.trim().toLowerCase();

  static String _normalizePermission(
    String permission,
    String defaultResource,
  ) {
    final (resource, codename) = RbacService.parsePermission(
      permission,
      defaultResource: defaultResource,
    );
    return '${_normalizePart(resource)}.${_normalizePart(codename)}';
  }
}
