/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_rbac_client/src/protocol/rbac_permission.dart'
    as _i6wtmqv0;
import 'package:serverpod_rbac_client/src/protocol/rbac_role.dart' as _iepuelvo;
import 'package:serverpod_rbac_client/src/protocol/rbac_user_permissions_info.dart'
    as _iratp19g;

/// Endpoint for managing RBAC roles, permissions, and assignments.
/// {@category Endpoint}
class EndpointRbacAdmin extends _isc.EndpointRef {
  EndpointRbacAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_rbac.rbacAdmin';

  /// Creates a new permission.
  _ida.Future<_i6wtmqv0.RbacPermission> createPermission({
    required String resource,
    required String codename,
    required String name,
    String? description,
  }) => caller.callServerEndpoint<_i6wtmqv0.RbacPermission>(
    'serverpod_rbac.rbacAdmin',
    'createPermission',
    {
      'resource': resource,
      'codename': codename,
      'name': name,
      'description': description,
    },
  );

  /// Lists all registered permissions.
  _ida.Future<List<_i6wtmqv0.RbacPermission>> listPermissions({
    String? resource,
  }) => caller.callServerEndpoint<List<_i6wtmqv0.RbacPermission>>(
    'serverpod_rbac.rbacAdmin',
    'listPermissions',
    {'resource': resource},
  );

  /// Deletes a permission by ID.
  _ida.Future<void> deletePermission(int permissionId) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbacAdmin',
        'deletePermission',
        {'permissionId': permissionId},
      );

  /// Creates a new role.
  _ida.Future<_iepuelvo.RbacRole> createRole({
    required String name,
    String? description,
    bool? isSuperuser,
  }) => caller.callServerEndpoint<_iepuelvo.RbacRole>(
    'serverpod_rbac.rbacAdmin',
    'createRole',
    {
      'name': name,
      'description': description,
      'isSuperuser': isSuperuser,
    },
  );

  /// Lists all roles.
  _ida.Future<List<_iepuelvo.RbacRole>> listRoles() =>
      caller.callServerEndpoint<List<_iepuelvo.RbacRole>>(
        'serverpod_rbac.rbacAdmin',
        'listRoles',
        {},
      );

  /// Deletes a role by name.
  _ida.Future<void> deleteRole(String name) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'deleteRole',
    {'name': name},
  );

  /// Assigns permissions to a role.
  _ida.Future<void> assignPermissionsToRole({
    required String roleName,
    required List<String> permissions,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'assignPermissionsToRole',
    {
      'roleName': roleName,
      'permissions': permissions,
    },
  );

  /// Removes permissions from a role.
  _ida.Future<void> removePermissionsFromRole({
    required String roleName,
    required List<String> permissions,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'removePermissionsFromRole',
    {
      'roleName': roleName,
      'permissions': permissions,
    },
  );

  /// Gets all permissions assigned to a role.
  _ida.Future<List<_i6wtmqv0.RbacPermission>> getRolePermissions(
    String roleName,
  ) => caller.callServerEndpoint<List<_i6wtmqv0.RbacPermission>>(
    'serverpod_rbac.rbacAdmin',
    'getRolePermissions',
    {'roleName': roleName},
  );

  /// Assigns a role to a user.
  _ida.Future<void> assignRoleToUser({
    required String userIdentifier,
    required String roleName,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'assignRoleToUser',
    {
      'userIdentifier': userIdentifier,
      'roleName': roleName,
    },
  );

  /// Removes a role from a user.
  _ida.Future<void> removeRoleFromUser({
    required String userIdentifier,
    required String roleName,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'removeRoleFromUser',
    {
      'userIdentifier': userIdentifier,
      'roleName': roleName,
    },
  );

  /// Gets all roles assigned to a user.
  _ida.Future<List<_iepuelvo.RbacRole>> getUserRoles(String userIdentifier) =>
      caller.callServerEndpoint<List<_iepuelvo.RbacRole>>(
        'serverpod_rbac.rbacAdmin',
        'getUserRoles',
        {'userIdentifier': userIdentifier},
      );

  /// Grants a permission directly to a user.
  _ida.Future<void> grantPermissionToUser({
    required String userIdentifier,
    required String permission,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'grantPermissionToUser',
    {
      'userIdentifier': userIdentifier,
      'permission': permission,
    },
  );

  /// Revokes a permission directly from a user.
  _ida.Future<void> revokePermissionFromUser({
    required String userIdentifier,
    required String permission,
    bool? explicitDeny,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'revokePermissionFromUser',
    {
      'userIdentifier': userIdentifier,
      'permission': permission,
      'explicitDeny': explicitDeny,
    },
  );

  /// Inspects full permissions info for any user.
  _ida.Future<_iratp19g.RbacUserPermissionsInfo> getUserPermissionsInfo({
    required String userIdentifier,
  }) => caller.callServerEndpoint<_iratp19g.RbacUserPermissionsInfo>(
    'serverpod_rbac.rbacAdmin',
    'getUserPermissionsInfo',
    {'userIdentifier': userIdentifier},
  );
}

/// Endpoint allowing clients to inspect their own RBAC permissions and roles.
/// {@category Endpoint}
class EndpointRbac extends _isc.EndpointRef {
  EndpointRbac(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_rbac.rbac';

  /// Checks if the current authenticated user is a superuser.
  _ida.Future<bool> isSuperuser() => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'isSuperuser',
    {},
  );

  /// Retrieves the current authenticated user's roles and permissions.
  _ida.Future<_iratp19g.RbacUserPermissionsInfo> getMyPermissions() =>
      caller.callServerEndpoint<_iratp19g.RbacUserPermissionsInfo>(
        'serverpod_rbac.rbac',
        'getMyPermissions',
        {},
      );

  /// Checks if the current authenticated user has a specific permission.
  _ida.Future<bool> hasPermission(String permission) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasPermission',
        {'permission': permission},
      );

  /// Checks if the current authenticated user has all specified permissions.
  _ida.Future<bool> hasAllPermissions(List<String> permissions) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasAllPermissions',
        {'permissions': permissions},
      );

  /// Checks if the current authenticated user has any specified permission.
  _ida.Future<bool> hasAnyPermission(List<String> permissions) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasAnyPermission',
        {'permissions': permissions},
      );

  /// Checks if the current authenticated user has a specific role.
  _ida.Future<bool> hasRole(String role) => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'hasRole',
    {'role': role},
  );

  /// Checks if the current authenticated user has any specified role.
  _ida.Future<bool> hasAnyRole(List<String> roles) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasAnyRole',
        {'roles': roles},
      );

  /// Checks if the current authenticated user has all specified roles.
  _ida.Future<bool> hasAllRoles(List<String> roles) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasAllRoles',
        {'roles': roles},
      );

  /// Enforces that the current authenticated user has [permission].
  _ida.Future<void> requirePermission(String permission) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbac',
        'requirePermission',
        {'permission': permission},
      );

  /// Enforces that the current authenticated user has all [permissions].
  _ida.Future<void> requireAllPermissions(List<String> permissions) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbac',
        'requireAllPermissions',
        {'permissions': permissions},
      );

  /// Enforces that the current authenticated user has any [permissions].
  _ida.Future<void> requireAnyPermission(List<String> permissions) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbac',
        'requireAnyPermission',
        {'permissions': permissions},
      );

  /// Enforces that the current authenticated user has [role].
  _ida.Future<void> requireRole(String role) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requireRole',
    {'role': role},
  );

  /// Enforces that the current authenticated user has all [roles].
  _ida.Future<void> requireAllRoles(List<String> roles) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbac',
        'requireAllRoles',
        {'roles': roles},
      );

  /// Enforces that the current authenticated user is a superuser.
  _ida.Future<void> requireSuperuser() => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requireSuperuser',
    {},
  );
}

class Caller extends _isc.ModuleEndpointCaller {
  Caller(_isc.ServerpodClientShared client) : super(client) {
    rbacAdmin = EndpointRbacAdmin(this);
    rbac = EndpointRbac(this);
  }

  late final EndpointRbacAdmin rbacAdmin;

  late final EndpointRbac rbac;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'serverpod_rbac.rbacAdmin': rbacAdmin,
    'serverpod_rbac.rbac': rbac,
  };
}
