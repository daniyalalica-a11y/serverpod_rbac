## Unreleased

- Remove tenant scopes and object-level permissions from the API and schema.
  Add a migration that drops object-grant data and merges scoped assignments
  into global user-role and user-permission records.
- Add repeatable `RbacSeeder.seed` for declarative permissions and roles.
- Simplify permission caching to user snapshots with request/local/global
  cache support and generation-based invalidation.
- Resolve `hasAllPermissions` and `hasAnyPermission` against one permission
  snapshot and write one summary audit event per composite check.

## 1.0.0

- Initial version, created by Stagehand
