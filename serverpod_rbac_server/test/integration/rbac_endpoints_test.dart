import 'package:serverpod/serverpod.dart';
import 'package:serverpod_rbac_server/serverpod_rbac_server.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given RBAC Endpoints', (sessionBuilder, endpoints) {
    late Session session;
    final rbac = RbacService.instance;

    setUp(() {
      session = sessionBuilder.build();
    });

    group('RbacEndpoint (Self-inspection)', () {
      test(
        'when user queries getMyPermissions then returns their assigned roles and permissions',
        () async {
          const userId = 'client-user-1';
          await rbac.createPermission(
            session,
            resource: 'profile',
            codename: 'edit',
            name: 'Edit Profile',
          );
          await rbac.createRole(session, name: 'member');
          await rbac.assignPermissionsToRole(
            session,
            roleName: 'member',
            permissions: ['profile.edit'],
          );
          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'member',
          );

          final authedSessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              userId,
              {},
            ),
          );

          final info = await endpoints.rbac.getMyPermissions(
            authedSessionBuilder,
          );
          expect(info.userIdentifier, userId);
          expect(info.roles, contains('member'));
          expect(info.permissions, contains('profile.edit'));

          final hasPerm = await endpoints.rbac.hasPermission(
            authedSessionBuilder,
            'profile.edit',
          );
          expect(hasPerm, isTrue);

          final hasRole = await endpoints.rbac.hasRole(
            authedSessionBuilder,
            'member',
          );
          expect(hasRole, isTrue);

          expect(
            await endpoints.rbac.hasAllPermissions(
              authedSessionBuilder,
              ['profile.edit'],
            ),
            isTrue,
          );
          expect(
            await endpoints.rbac.hasAnyPermission(
              authedSessionBuilder,
              ['profile.edit', 'profile.delete'],
            ),
            isTrue,
          );
          expect(
            await endpoints.rbac.hasAllRoles(
              authedSessionBuilder,
              ['member'],
            ),
            isTrue,
          );
          expect(
            await endpoints.rbac.hasAnyRole(
              authedSessionBuilder,
              ['administrator', 'member'],
            ),
            isTrue,
          );
          await endpoints.rbac.requireAllRoles(
            authedSessionBuilder,
            ['member'],
          );
        },
      );
    });

    group('RbacAdminEndpoint (Administrative Control)', () {
      test(
        'when unprivileged user calls admin endpoint then throws RbacException',
        () async {
          const regularUserId = 'regular-user';
          final regularSessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              regularUserId,
              {},
            ),
          );

          expect(
            () => endpoints.rbacAdmin.createRole(
              regularSessionBuilder,
              name: 'hacker_role',
            ),
            throwsA(
              isA<RbacException>().having(
                (e) => e.reason,
                'reason',
                RbacExceptionReason.permissionDenied,
              ),
            ),
          );
        },
      );

      test(
        'when superuser calls admin endpoint then successfully creates role and permission',
        () async {
          const adminUserId = 'superadmin-user';
          final adminSessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              adminUserId,
              {Scope.admin},
            ),
          );

          final newRole = await endpoints.rbacAdmin.createRole(
            adminSessionBuilder,
            name: 'content_creator',
            description: 'Creators of content',
          );
          expect(newRole.name, 'content_creator');

          final newPerm = await endpoints.rbacAdmin.createPermission(
            adminSessionBuilder,
            resource: 'video',
            codename: 'upload',
            name: 'Upload Video',
          );
          expect(newPerm.codename, 'upload');

          await endpoints.rbacAdmin.assignPermissionsToRole(
            adminSessionBuilder,
            roleName: 'content_creator',
            permissions: ['video.upload'],
          );

          final perms = await endpoints.rbacAdmin.getRolePermissions(
            adminSessionBuilder,
            'content_creator',
          );
          expect(perms.any((p) => p.codename == 'upload'), isTrue);
        },
      );
    });
  });
}
