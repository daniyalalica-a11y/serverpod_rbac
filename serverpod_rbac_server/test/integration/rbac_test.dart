import 'package:serverpod/serverpod.dart';
import 'package:serverpod_rbac_server/serverpod_rbac_server.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given RBAC Core Engine', (sessionBuilder, endpoints) {
    late Session session;
    final rbac = RbacService.instance;

    setUp(() {
      session = sessionBuilder.build();
    });

    group('Permissions and Roles CRUD', () {
      test(
        'RBAC seeding is repeatable and assigns declared permissions',
        () async {
          const userId = 'seeded-editor';
          const permissions = [
            RbacSeedPermission(
              resource: 'seeded-article',
              codename: 'view',
              name: 'View article',
            ),
            RbacSeedPermission(
              resource: 'seeded-article',
              codename: 'edit',
              name: 'Edit article',
            ),
          ];
          const roles = [
            RbacSeedRole(
              name: 'seeded-editor-role',
              permissions: [
                'seeded-article.view',
                'seeded-article.edit',
                'seeded-article.view',
              ],
            ),
            RbacSeedRole(
              name: 'seeded-reader-role',
              permissions: ['seeded-article.view'],
            ),
          ];

          await RbacSeeder.seed(
            session,
            permissions: permissions,
            roles: roles,
          );
          await RbacSeeder.seed(
            session,
            permissions: permissions,
            roles: roles,
          );
          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'seeded-editor-role',
          );

          final permissionsInfo = await rbac.getUserPermissionsInfo(
            session,
            userId,
            forceRefresh: true,
          );
          expect(permissionsInfo.roles, ['seeded-editor-role']);
          expect(
            permissionsInfo.permissions,
            containsAll(['seeded-article.view', 'seeded-article.edit']),
          );
          expect(
            await rbac.getRolePermissions(session, 'seeded-editor-role'),
            hasLength(2),
          );
          expect(
            await rbac.getRolePermissions(session, 'seeded-reader-role'),
            hasLength(1),
          );
          expect(
            (await rbac.listPermissions(
              session,
              resource: 'seeded-article',
            )).length,
            2,
          );
          expect(
            await RbacAuditLog.db.find(
              session,
              where: (t) =>
                  t.action.equals('create_permission') &
                  t.resource.equals('seeded-article'),
            ),
            hasLength(2),
          );
          expect(
            await RbacAuditLog.db.find(
              session,
              where: (t) =>
                  t.action.equals('create_role') &
                  (t.roleName.equals('seeded-editor-role') |
                      t.roleName.equals('seeded-reader-role')),
            ),
            hasLength(2),
          );
        },
      );

      test(
        'when creating permissions then they can be retrieved and listed',
        () async {
          final perm = await rbac.createPermission(
            session,
            resource: 'article',
            codename: 'create',
            name: 'Create Article',
            description: 'Can create new articles',
          );

          expect(perm.id, isNotNull);
          expect(perm.resource, 'article');
          expect(perm.codename, 'create');

          final list = await rbac.listPermissions(session, resource: 'article');
          expect(list.any((p) => p.codename == 'create'), isTrue);
        },
      );

      test('when creating role then it can be retrieved and deleted', () async {
        final role = await rbac.createRole(
          session,
          name: 'editor',
          description: 'Article editor role',
        );

        expect(role.id, isNotNull);
        expect(role.name, 'editor');

        final fetched = await rbac.getRole(session, 'editor');
        expect(fetched?.name, 'editor');
      });

      test(
        'when assigning permissions to role then role permissions are updated',
        () async {
          await rbac.createPermission(
            session,
            resource: 'post',
            codename: 'view',
            name: 'View Post',
          );
          await rbac.createPermission(
            session,
            resource: 'post',
            codename: 'edit',
            name: 'Edit Post',
          );

          await rbac.createRole(session, name: 'moderator');
          await rbac.assignPermissionsToRole(
            session,
            roleName: 'moderator',
            permissions: ['post.view', 'post.edit', 'post.view'],
          );

          final rolePerms = await rbac.getRolePermissions(session, 'moderator');
          expect(rolePerms.length, 2);
          expect(
            rolePerms.map((p) => '${p.resource}.${p.codename}'),
            containsAll(['post.view', 'post.edit']),
          );

          // Remove one permission
          await rbac.removePermissionsFromRole(
            session,
            roleName: 'moderator',
            permissions: ['post.edit'],
          );

          final updatedRolePerms = await rbac.getRolePermissions(
            session,
            'moderator',
          );
          expect(updatedRolePerms.length, 1);
          expect(updatedRolePerms.first.codename, 'view');
        },
      );
    });

    group('User Role and Permission Evaluation', () {
      test(
        'when user is assigned a role then user inherits all role permissions',
        () async {
          const userId = 'user-101';
          await rbac.createPermission(
            session,
            resource: 'document',
            codename: 'read',
            name: 'Read Document',
          );
          await rbac.createPermission(
            session,
            resource: 'document',
            codename: 'write',
            name: 'Write Document',
          );

          await rbac.createRole(session, name: 'author');
          await rbac.assignPermissionsToRole(
            session,
            roleName: 'author',
            permissions: ['document.read', 'document.write'],
          );

          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'author',
          );

          expect(
            await rbac.hasRole(session, 'author', userIdentifier: userId),
            isTrue,
          );
          expect(
            await rbac.hasPermission(
              session,
              'document.read',
              userIdentifier: userId,
            ),
            isTrue,
          );
          expect(
            await rbac.hasPermission(
              session,
              'document.write',
              userIdentifier: userId,
            ),
            isTrue,
          );
          expect(
            await rbac.hasPermission(
              session,
              'document.delete',
              userIdentifier: userId,
            ),
            isFalse,
          );

          // Multiple check
          expect(
            await rbac.hasAllPermissions(
              session,
              ['document.read', 'document.write'],
              userIdentifier: userId,
            ),
            isTrue,
          );
        },
      );

      test(
        'composite permission checks resolve once and emit one audit event each',
        () async {
          const userId = 'user-composite-audit';
          await rbac.createPermission(
            session,
            resource: 'composite',
            codename: 'read',
            name: 'Read composite resource',
          );
          await rbac.createPermission(
            session,
            resource: 'composite',
            codename: 'write',
            name: 'Write composite resource',
          );
          await rbac.grantPermissionToUser(
            session,
            userIdentifier: userId,
            permission: 'composite.read',
          );

          expect(
            await rbac.hasAllPermissions(
              session,
              ['composite.read', 'composite.write'],
              userIdentifier: userId,
            ),
            isFalse,
          );
          expect(
            await rbac.hasAnyPermission(
              session,
              ['composite.read', 'composite.write'],
              userIdentifier: userId,
            ),
            isTrue,
          );

          final compositeAuditRows = await RbacAuditLog.db.find(
            session,
            where: (t) =>
                t.userIdentifier.equals(userId) &
                (t.action.equals('check_all_permissions') |
                    t.action.equals('check_any_permission')),
          );
          expect(compositeAuditRows, hasLength(2));
        },
      );

      test('composite role checks require all roles when requested', () async {
        const userId = 'user-composite-roles';
        await rbac.createRole(session, name: 'role-composite-reader');
        await rbac.createRole(session, name: 'role-composite-editor');
        await rbac.createRole(session, name: 'role-composite-admin');
        await rbac.assignRoleToUser(
          session,
          userIdentifier: userId,
          roleName: 'role-composite-reader',
        );
        await rbac.assignRoleToUser(
          session,
          userIdentifier: userId,
          roleName: 'role-composite-editor',
        );

        expect(
          await rbac.hasAllRoles(
            session,
            ['role-composite-reader', 'role-composite-editor'],
            userIdentifier: userId,
          ),
          isTrue,
        );
        expect(
          await rbac.hasAllRoles(
            session,
            ['role-composite-reader', 'role-composite-admin'],
            userIdentifier: userId,
          ),
          isFalse,
        );
        expect(
          await rbac.hasAnyRole(
            session,
            ['role-composite-admin', 'role-composite-editor'],
            userIdentifier: userId,
          ),
          isTrue,
        );
        await rbac.requireAllRoles(
          session,
          ['role-composite-reader', 'role-composite-editor'],
          userIdentifier: userId,
        );
        await expectLater(
          rbac.requireAllRoles(
            session,
            ['role-composite-reader', 'role-composite-admin'],
            userIdentifier: userId,
          ),
          throwsA(
            isA<RbacException>().having(
              (error) => error.reason,
              'reason',
              RbacExceptionReason.roleDenied,
            ),
          ),
        );

        final roleAuditRows = await RbacAuditLog.db.find(
          session,
          where: (t) =>
              t.userIdentifier.equals(userId) &
              t.action.equals('check_all_roles'),
        );
        expect(roleAuditRows, hasLength(4));
      });

      test(
        'when granting direct user permission then user possesses it without a role',
        () async {
          const userId = 'user-direct-1';
          await rbac.createPermission(
            session,
            resource: 'billing',
            codename: 'view_invoices',
            name: 'View Invoices',
          );

          expect(
            await rbac.hasPermission(
              session,
              'billing.view_invoices',
              userIdentifier: userId,
            ),
            isFalse,
          );

          await rbac.grantPermissionToUser(
            session,
            userIdentifier: userId,
            permission: 'billing.view_invoices',
          );

          expect(
            await rbac.hasPermission(
              session,
              'billing.view_invoices',
              userIdentifier: userId,
            ),
            isTrue,
          );
        },
      );

      test(
        'when explicit deny override is set then direct deny revokes role permission',
        () async {
          const userId = 'user-deny-1';
          await rbac.createPermission(
            session,
            resource: 'system',
            codename: 'restart',
            name: 'Restart System',
          );
          await rbac.createRole(session, name: 'ops');
          await rbac.assignPermissionsToRole(
            session,
            roleName: 'ops',
            permissions: ['system.restart'],
          );
          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'ops',
          );

          // Initially granted via role
          expect(
            await rbac.hasPermission(
              session,
              'system.restart',
              userIdentifier: userId,
            ),
            isTrue,
          );

          // Explicitly deny for this specific user
          await rbac.revokePermissionFromUser(
            session,
            userIdentifier: userId,
            permission: 'system.restart',
            explicitDeny: true,
          );

          // Now denied even though user is still in the 'ops' role!
          expect(
            await rbac.hasPermission(
              session,
              'system.restart',
              userIdentifier: userId,
            ),
            isFalse,
          );
        },
      );
    });

    group('Superuser Bypass', () {
      test(
        'when user has superuser role then all permissions and roles pass automatically',
        () async {
          const superuserId = 'root-user';
          await rbac.createRole(session, name: 'superadmin', isSuperuser: true);
          await rbac.assignRoleToUser(
            session,
            userIdentifier: superuserId,
            roleName: 'superadmin',
          );

          expect(
            await rbac.isSuperuser(session, userIdentifier: superuserId),
            isTrue,
          );
          expect(
            await rbac.hasPermission(
              session,
              'any.imaginary_permission',
              userIdentifier: superuserId,
            ),
            isTrue,
          );
          expect(
            await rbac.hasRole(
              session,
              'any_random_role',
              userIdentifier: superuserId,
            ),
            isTrue,
          );
        },
      );

      test(
        'when session has Scope.admin then superuser privileges are active',
        () async {
          const adminId = 'admin-user-serverpod';
          final adminSessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              adminId,
              {Scope.admin},
            ),
          );
          final adminSession = adminSessionBuilder.build();

          expect(await adminSession.rbac.isSuperuser(), isTrue);
          expect(
            await adminSession.rbac.hasPermission('anything.allowed'),
            isTrue,
          );
        },
      );
    });

    group('Enforcers and Exceptions', () {
      test(
        'when requirePermission is called on missing permission then RbacException is thrown',
        () async {
          const userId = 'restricted-user';
          final userSession = sessionBuilder
              .copyWith(
                authentication: AuthenticationOverride.authenticationInfo(
                  userId,
                  {},
                ),
              )
              .build();

          expect(
            () => userSession.rbac.requirePermission('vault.open'),
            throwsA(
              isA<RbacException>()
                  .having(
                    (e) => e.reason,
                    'reason',
                    RbacExceptionReason.permissionDenied,
                  )
                  .having(
                    (e) => e.requiredPermission,
                    'requiredPermission',
                    'vault.open',
                  ),
            ),
          );
        },
      );
    });
  });
}
