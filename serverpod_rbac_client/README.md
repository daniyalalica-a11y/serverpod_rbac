# `serverpod_rbac_client`

Generated Serverpod client protocol package for `serverpod_rbac_server`.
It contains serialized RBAC models and endpoint connector types used by
Serverpod clients.

The server package exposes the authorization APIs (`session.rbac`) and
endpoints; permission decisions must be enforced on the server. Client-side
checks may be used for presentation only and must not replace server
authorization.

Regenerate this package together with the server protocol after changing
Serverpod models or endpoint signatures. Do not edit generated protocol files
by hand.

The package targets Serverpod 4.0.4. The server package enforces global
role/permission authorization; client-side checks are for presentation only.
Tenant and record-level authorization must be implemented and enforced by the
application server.

For server configuration, caching, audit, migration, and deployment guidance,
see the repository [DOCS.md](../DOCS.md).