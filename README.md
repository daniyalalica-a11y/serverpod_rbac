# Serverpod RBAC

Django-inspired role-based authorization for Serverpod 4.0.4. Define named
permissions, assign them to roles, assign roles to users, and enforce access in
server-side endpoints.

## Features

- Named `resource.codename` permissions and reusable roles.
- Direct user grants and explicit user denials.
- Superuser support, including Serverpod's `Scope.admin`.
- Cached permission snapshots with request-local, local, or shared cache
  backends and generation-based invalidation.
- Optional database audit records for authorization decisions and changes.
- Idempotent developer/deployment seeding with `RbacSeeder`.

Authorization is global: this package does not provide tenant scopes or
object-level permissions. Enforce tenant membership and row ownership in your
application's own query and authorization rules.

## Quick start

Install both module packages in their respective projects. From the Serverpod
server:

```powershell
dart pub add serverpod_rbac_server
```

From the Flutter/client project:

```powershell
dart pub add serverpod_rbac_client
```

Then register the module in the server's `config/generator.yaml`, run
`dart pub get` and `serverpod generate`, and apply the module migrations. See
the [installation guide](./DOCS.md#installation-and-serverpod-integration)
for the full setup. Pub dependencies are project-local, so adding the server
package does not add the client package to a separate Flutter project's
`pubspec.yaml`.

```dart
// Register these definitions from a trusted startup/bootstrap task.
await RbacSeeder.seed(
  session,
  permissions: const [
    RbacSeedPermission(
      resource: 'article',
      codename: 'edit',
      name: 'Edit article',
    ),
  ],
  roles: const [
    RbacSeedRole(name: 'editor', permissions: ['article.edit']),
  ],
);

// In an authenticated Serverpod endpoint:
await session.rbac.requirePermission('article.edit');
```

Configure a shared Serverpod cache and `RbacCacheMedium.global` for multi-node
deployments. See the [production and API guide](./DOCS.md), the
[server package](./serverpod_rbac_server/README.md), and the
[client package](./serverpod_rbac_client/README.md).

The server and client packages both target Serverpod 4.0.4. Apply and verify
database migrations in staging before deploying.
