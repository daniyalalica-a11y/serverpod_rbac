# `serverpod_rbac_server`

Server-side authorization library for the Serverpod RBAC module. Import
`package:serverpod_rbac_server/serverpod_rbac_server.dart` to access
`RbacService`, configuration, generated protocol types, and the `Session.rbac`
extension.

## Configuration

Configure once during server startup:

```dart
RbacService.instance.configure(
  RbacConfig(
    cacheMedium: RbacCacheMedium.global,
    cacheLifetime: const Duration(minutes: 1),
    enableRequestCache: true,
    enableAuditLog: true,
  ),
);
```

Use `RbacCacheMedium.global` when running multiple server nodes and configure
Serverpod's shared cache accordingly. `local` is appropriate only when the
application can tolerate node-local cache state. Mutations performed through
the RBAC service invalidate the matching user or global cache generation.

## Authorization

```dart
await session.rbac.requirePermission('invoice.view');
```

This package implements global role/permission authorization only. Enforce
tenant membership and record ownership in your application's authorization
logic and constrain database queries accordingly.

The package contains the model definitions under `lib/src/models`. After
changing a `.spy.yaml` model, run `serverpod generate`, review the generated
code, and create/review a database migration. Test migrations on staging
before production.

For convenient idempotent permission and role setup, see `RbacSeeder.seed`.
See the repository [DOCS.md](../DOCS.md) for detailed API behavior, caching,
audit, migrations, and deployment guidance.