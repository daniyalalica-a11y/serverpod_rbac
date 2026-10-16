import 'package:serverpod/serverpod.dart';

/// Defines the storage backend used for RBAC process-level caching.
enum RbacCacheMedium {
  /// In-memory cache on the local server instance ([Session.caches.local]).
  ///
  /// Fastest option for single-server setups. Requires zero external infrastructure.
  local,

  /// Redis distributed cache ([Session.caches.global]).
  ///
  /// Shared across all server instances in a cluster. Essential for multi-node deployments.
  /// Requires Redis configured in your Serverpod configuration.
  global,

  /// Completely disables process-level caching.
  ///
  /// Forces queries directly to the database on every check (unless served by
  /// the request-level weak-reference cache if enabled). Useful for debugging.
  disabled,
}

/// Central configuration for the Serverpod RBAC system.
class RbacConfig {
  /// The caching backend to use: local in-memory, global Redis, or disabled.
  /// Defaults to [RbacCacheMedium.local].
  RbacCacheMedium cacheMedium;

  /// Time-to-live for cached user permissions.
  /// Defaults to 1 minute to bound stale authorization decisions.
  Duration cacheLifetime;

  /// Whether to enable the request-scoped weak-reference cache ([Expando]).
  ///
  /// When enabled, repeating the same permission check multiple times within the
  /// exact same HTTP/WebSocket request incurs 0 database queries and 0 cache round-trips.
  /// Defaults to `true`.
  bool enableRequestCache;

  /// Whether authorization checks and administrative mutations are recorded
  /// to the `serverpod_rbac_audit_log` database table.
  /// Defaults to `true`.
  bool enableAuditLog;

  /// Default resource prefix applied when a permission string is supplied without
  /// a resource dot prefix (e.g. `'view'` becomes `'global.view'`).
  /// Defaults to `'global'`.
  String defaultResource;

  /// Whether superusers automatically bypass all permission and role checks.
  /// Defaults to `true`.
  bool superusersBypassAll;

  /// Creates a new [RbacConfig] with the specified settings.
  RbacConfig({
    this.cacheMedium = RbacCacheMedium.local,
    this.cacheLifetime = const Duration(minutes: 1),
    this.enableRequestCache = true,
    this.enableAuditLog = true,
    this.defaultResource = 'global',
    this.superusersBypassAll = true,
  });

  /// Creates a copy of this configuration with the given fields replaced.
  RbacConfig copyWith({
    RbacCacheMedium? cacheMedium,
    Duration? cacheLifetime,
    bool? enableRequestCache,
    bool? enableAuditLog,
    String? defaultResource,
    bool? superusersBypassAll,
  }) {
    return RbacConfig(
      cacheMedium: cacheMedium ?? this.cacheMedium,
      cacheLifetime: cacheLifetime ?? this.cacheLifetime,
      enableRequestCache: enableRequestCache ?? this.enableRequestCache,
      enableAuditLog: enableAuditLog ?? this.enableAuditLog,
      defaultResource: defaultResource ?? this.defaultResource,
      superusersBypassAll: superusersBypassAll ?? this.superusersBypassAll,
    );
  }
}
