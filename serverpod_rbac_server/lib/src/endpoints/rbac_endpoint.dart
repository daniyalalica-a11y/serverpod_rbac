import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../session_rbac_extension.dart';

/// Endpoint allowing clients to inspect their own RBAC permissions and roles.
class RbacEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Checks if the current authenticated user is a superuser.
  Future<bool> isSuperuser(Session session) async {
    return session.rbac.isSuperuser();
  }

  /// Retrieves the current authenticated user's roles and permissions.
  Future<RbacUserPermissionsInfo> getMyPermissions(Session session) async {
    final info = await session.rbac.getPermissionsInfo();
    if (info == null) {
      throw RbacException(
        message: 'Unable to resolve permissions for unauthenticated user',
        reason: RbacExceptionReason.notAuthenticated,
      );
    }
    return info;
  }

  /// Checks if the current authenticated user has a specific permission.
  Future<bool> hasPermission(Session session, String permission) async {
    return session.rbac.hasPermission(permission);
  }

  /// Checks if the current authenticated user has all specified permissions.
  Future<bool> hasAllPermissions(
    Session session,
    List<String> permissions,
  ) async {
    return session.rbac.hasAllPermissions(permissions);
  }

  /// Checks if the current authenticated user has any specified permission.
  Future<bool> hasAnyPermission(
    Session session,
    List<String> permissions,
  ) async {
    return session.rbac.hasAnyPermission(permissions);
  }

  /// Checks if the current authenticated user has a specific role.
  Future<bool> hasRole(Session session, String role) async {
    return session.rbac.hasRole(role);
  }

  /// Checks if the current authenticated user has any specified role.
  Future<bool> hasAnyRole(Session session, List<String> roles) async {
    return session.rbac.hasAnyRole(roles);
  }

  /// Checks if the current authenticated user has all specified roles.
  Future<bool> hasAllRoles(Session session, List<String> roles) async {
    return session.rbac.hasAllRoles(roles);
  }

  /// Enforces that the current authenticated user has [permission].
  Future<void> requirePermission(Session session, String permission) async {
    await session.rbac.requirePermission(permission);
  }

  /// Enforces that the current authenticated user has all [permissions].
  Future<void> requireAllPermissions(
    Session session,
    List<String> permissions,
  ) async {
    await session.rbac.requireAllPermissions(permissions);
  }

  /// Enforces that the current authenticated user has any [permissions].
  Future<void> requireAnyPermission(
    Session session,
    List<String> permissions,
  ) async {
    await session.rbac.requireAnyPermission(permissions);
  }

  /// Enforces that the current authenticated user has [role].
  Future<void> requireRole(Session session, String role) async {
    await session.rbac.requireRole(role);
  }

  /// Enforces that the current authenticated user has all [roles].
  Future<void> requireAllRoles(Session session, List<String> roles) async {
    await session.rbac.requireAllRoles(roles);
  }

  /// Enforces that the current authenticated user is a superuser.
  Future<void> requireSuperuser(Session session) async {
    await session.rbac.requireSuperuser();
  }
}
