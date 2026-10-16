# Serverpod RBAC Guide

Django-inspired role-based access control for Serverpod 4.0.4. This module
supports global permissions, reusable roles, direct per-user grants/denials,
superusers, caching, audit logging, and declarative seeding.

## Contents

1. [Packages and requirements](#packages-and-requirements)
2. [Authorization model](#authorization-model)
3. [Installation and setup](#installation-and-setup)
4. [Defining and seeding permissions](#defining-and-seeding-permissions)
5. [Checking permissions](#checking-permissions)
6. [Managing assignments](#managing-assignments)
7. [Caching and invalidation](#caching-and-invalidation)
8. [Audit logging](#audit-logging)
9. [Production deployment](#production-deployment)
10. [Migrations and upgrade notes](#migrations-and-upgrade-notes)
11. [Testing](#testing)

## Packages and requirements

The workspace contains:

- `serverpod_rbac_server`: authorization service, `Session.rbac` extension,
  server endpoints, cache configuration, audit models, and seeding API.
- `serverpod_rbac_client`: generated client protocol and endpoint connectors.

Both packages target Serverpod 4.0.4 and Dart SDK `^3.12.2`. The server
application remains responsible for authentication and for invoking
authorization checks before protected operations.

## Authorization model

The data model follows Django's permission and group approach:

| Concept | Model | Purpose |
|---|---|---|
| Permission | `RbacPermission` | A named `resource.codename` capability |
| Role | `RbacRole` | A reusable collection of permissions |
| Role permission | `RbacRolePermission` | Associates a permission with a role |
| User role | `RbacUserRole` | Associates a Serverpod user identifier with a role |
| Direct user permission | `RbacUserPermission` | Grants or explicitly denies one permission |
| Audit event | `RbacAuditLog` | Records authorization decisions and administration |

Permissions are global. There is deliberately no tenant-scope or object-level
permission table/API. For tenant or row access, first enforce the corresponding
tenant membership/ownership in application code and constrain the data query
itself. Never fetch unrestricted rows and treat a UI-side permission check as
an access-control boundary.

Direct permission denials remove that permission from the resolved snapshot,
even when a role grants it. A superuser bypasses normal checks when
`superusersBypassAll` is enabled (the default). Serverpod authenticated users
with `Scope.admin` are treated as superusers.

Permission keys use `resource.codename`, for example `invoice.view`. A bare
codename uses the configured `defaultResource` (default: `global`). Checks also
support `resource.*` and `*.*` wildcard grants.

## Installation and setup

Add both packages to the Serverpod project workspace and keep the package
versions aligned with the application. Import server APIs with:

```dart
import 'package:serverpod_rbac_server/serverpod_rbac_server.dart';
```

Configure the singleton once during server startup:

```dart
RbacService.instance.configure(
  RbacConfig(
    cacheMedium: RbacCacheMedium.global,
    cacheLifetime: const Duration(minutes: 2),
    enableRequestCache: true,
    enableAuditLog: true,
  ),
);
```

Use `RbacCacheMedium.global` when the Serverpod deployment has a shared cache
backend configured. `local` is node-local; use it only if temporary per-node
differences are acceptable. `disabled` bypasses process-level caches.

Generate client/server code after model or endpoint changes:

```powershell
serverpod generate
```

Register the generated `rbac` and `rbacAdmin` endpoints through the project's
normal Serverpod endpoint setup. Administrative endpoints require login and
then require either superuser status or `rbac.manage`.

## Defining and seeding permissions

Use `RbacSeeder.seed` from a trusted bootstrap/deployment script or startup
session. Seeding is additive and idempotent: it creates missing definitions
and role-permission assignments without deleting existing grants. Definitions
and role assignments are inserted in batches to reduce database round trips.

```dart
await RbacSeeder.seed(
  session,
  permissions: const [
    RbacSeedPermission(
      resource: 'article',
      codename: 'view',
      name: 'Can view article',
    ),
    RbacSeedPermission(
      resource: 'article',
      codename: 'edit',
      name: 'Can edit article',
    ),
    RbacSeedPermission(
      resource: 'article',
      codename: 'delete',
      name: 'Can delete article',
    ),
  ],
  roles: const [
    RbacSeedRole(
      name: 'reader',
      description: 'Can read articles',
      permissions: ['article.view'],
    ),
    RbacSeedRole(
      name: 'editor',
      description: 'Can view and edit articles',
      permissions: ['article.view', 'article.edit'],
    ),
    RbacSeedRole(
      name: 'site_admin',
      description: 'Application superuser role',
      isSuperuser: true,
      permissions: [],
    ),
  ],
);
```

Assign a seeded role to a user after seeding:

```dart
await RbacService.instance.assignRoleToUser(
  session,
  userIdentifier: userIdentifier,
  roleName: 'editor',
);
```

The seeder is not a client API. Do not expose bootstrap seeding directly to
untrusted callers. Seed permission definitions before role permissions; the
seeder does this ordering automatically.

## Checking permissions

Check without throwing, or enforce the decision with `require*` methods:

```dart
if (await session.rbac.hasPermission('article.edit')) {
  // Show an optional capability, or continue non-sensitive logic.
}

await session.rbac.requirePermission('article.edit');
await session.rbac.requireRole('editor');
await session.rbac.requireAllPermissions([
  'article.view',
  'article.edit',
]);
await session.rbac.requireAnyPermission([
  'article.edit',
  'article.delete',
]);
if (await session.rbac.hasAllRoles(['editor', 'publisher'])) {
  // The user has both roles.
}
await session.rbac.requireAllRoles(['editor', 'publisher']);
```

`requirePermission`, `requireRole`, `requireAllPermissions`, and
`requireAnyPermission`, and `requireAllRoles` throw `RbacException` when
authentication or authorization fails. The `rbac` endpoint exposes the
authenticated user's permission and role checks and their corresponding
enforcers. Prefer enforcement in server endpoints/services over client-side
checks. A client-side check is only suitable for presentation.

Get the resolved snapshot for the authenticated user:

```dart
final info = await session.rbac.getPermissionsInfo();
final permissions = await session.rbac.getAllPermissions();
final roles = await session.rbac.getRoles();
```

Service checks also support an explicit user identifier for administrative and
background tasks:

```dart
final allowed = await RbacService.instance.hasPermission(
  session,
  'article.edit',
  userIdentifier: userIdentifier,
);
```

## Managing assignments

Permissions and roles are created idempotently by the service:

```dart
final rbac = RbacService.instance;
await rbac.createPermission(
  session,
  resource: 'invoice',
  codename: 'approve',
  name: 'Approve invoice',
);
await rbac.createRole(session, name: 'approver');
await rbac.assignPermissionsToRole(
  session,
  roleName: 'approver',
  permissions: ['invoice.approve'],
);
await rbac.assignRoleToUser(
  session,
  userIdentifier: userIdentifier,
  roleName: 'approver',
);
```

Direct user permissions are useful for exceptional grants or denials:

```dart
await rbac.grantPermissionToUser(
  session,
  userIdentifier: userIdentifier,
  permission: 'invoice.approve',
);

// An explicit deny overrides permissions inherited from roles.
await rbac.revokePermissionFromUser(
  session,
  userIdentifier: userIdentifier,
  permission: 'invoice.approve',
  explicitDeny: true,
);

// Remove the explicit user entry entirely.
await rbac.revokePermissionFromUser(
  session,
  userIdentifier: userIdentifier,
  permission: 'invoice.approve',
);
```

Mutations through `RbacService` invalidate affected permission snapshots.
Direct database writes bypass that behavior; call the appropriate
`RbacService.instance.cache.invalidateUser` or `invalidateAll` after such
updates.

## Caching and invalidation

`getUserPermissionsInfo` resolves roles and effective permissions into one
`RbacUserPermissionsInfo` snapshot. Subsequent checks reuse that snapshot.

- Request cache: enabled by default; reuses resolved snapshots during the
  lifetime of the session.
- Local cache: fast, process-local Serverpod cache.
- Global cache: shared Serverpod cache for multi-node deployments.
- Disabled: always resolves from the database outside of request handling.

The default cache lifetime is one minute. Set it to match the acceptable
authorization staleness for the application. RBAC mutations bump the user's
or global generation so new requests don't reuse stale data. Use the same
shared cache for every server node when using the global backend.

Cache read/write failures are logged and authorization resolution falls back
to the database. Monitor these warnings and backend latency; a cache outage
should not turn into an authorization grant.

## Audit logging

Audit logging is enabled by default and writes authorization decisions and
administrative changes to `serverpod_rbac_audit_log`. Disable it with
`enableAuditLog: false` if the application has a separate auditable event
pipeline or intentionally does not need these records.

Audit persistence errors are logged as warnings and do not change the
authorization result. Define retention, access, backup, and deletion policies
for audit rows based on your compliance requirements. Avoid putting secrets or
unnecessary personal data in `details`.

## Production deployment

- Use a shared Serverpod cache backend and `RbacCacheMedium.global` for
  multi-node production.
- Set the cache lifetime according to revocation latency/security needs.
- Apply least privilege: grant capabilities to roles and roles to users; limit
  direct user grants and superuser roles.
- Enforce tenant membership and record ownership in application-level
  authorization and in database queries. This library does not implement
  tenant or object-level permission checks.
- Use the `require*` methods at server-side trust boundaries. Never rely on a
  client hiding a control or filtering returned records.
- Keep RBAC configuration stable after startup; configure before serving
  requests.
- Monitor database/cache latency, RBAC cache warnings, audit write warnings,
  and audit table growth.
- Configure backups and retention for the permission and audit tables. Test
  both cache invalidation and permission revocation in staging.
- Apply migrations and verify the schema against production data before
  rollout.

RBAC checks may write an audit record per decision. If request volume is high,
measure database write load with audit enabled and choose an application-level
event pipeline or disable audit deliberately if required. Permission snapshots
and request caching reduce repeated permission-resolution queries; endpoint
and application data queries remain the caller's responsibility to optimize.

## Migrations and upgrade notes

After changing a `.spy.yaml` model:

```powershell
serverpod generate
serverpod create-migration
```

Review the generated SQL, apply it to a staging copy, and verify application
data before deploying. The migration that removes scopes and
object-level permissions drops the `serverpod_rbac_object_permission` table
and audit metadata columns `scope` and `objectId`. It also merges duplicate
scoped user-role and user-permission assignments before adding global unique
indexes, preserving the most recently created row for each user/role or
user/permission pair. Back up data and review this intentional data loss before
production rollout.

The earlier scoped APIs have been removed: remove `scope` arguments and replace
`hasObjectPermission`/`getPermittedObjectIds` with application-specific
tenant/ownership checks. The latest schema migration only moves forward; it
does not restore dropped object grants or audit metadata on downgrade.

## Testing

Run the server package tests:

```powershell
cd serverpod_rbac_server
dart test
```

Run static analysis for both packages from the workspace root:

```powershell
dart analyze serverpod_rbac_server serverpod_rbac_client
```

Integration tests cover permission resolution, direct grants and denials,
cache invalidation, endpoint access, and repeatable seeding.
