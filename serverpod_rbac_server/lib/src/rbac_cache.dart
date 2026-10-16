import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import 'generated/protocol.dart';
import 'rbac_config.dart';
import 'rbac_service.dart';

/// Cache manager for RBAC permissions and user roles.
class RbacCache {
  /// Default time-to-live for cached permissions.
  Duration get defaultLifetime => RbacService.instance.config.cacheLifetime;
  set defaultLifetime(Duration value) =>
      RbacService.instance.config.cacheLifetime = value;

  int _globalVersion = 1;

  static final Expando<Map<String, Object?>> _sessionCaches =
      Expando<Map<String, Object?>>();

  Map<String, Object?> _getSessionCache(Session session) {
    return _sessionCaches[session] ??= <String, Object?>{};
  }

  Future<String?> _readGeneration(Session session, String key) async {
    final requestKey = 'rbac-generation:$key';
    final requestCache = _getSessionCache(session);
    final cachedGeneration = requestCache[requestKey];
    if (RbacService.instance.config.enableRequestCache &&
        cachedGeneration is String) {
      return cachedGeneration == '0' ? null : cachedGeneration;
    }

    final generation = switch (RbacService.instance.config.cacheMedium) {
      RbacCacheMedium.global => await session.caches.global.get<String>(key),
      RbacCacheMedium.local => await session.caches.local.get<String>(key),
      RbacCacheMedium.disabled => null,
    };
    if (RbacService.instance.config.enableRequestCache) {
      requestCache[requestKey] = generation ?? '0';
    }
    return generation;
  }

  Future<void> _writeGeneration(
    Session session,
    String key,
    String value,
  ) async {
    const lifetime = Duration(days: 36500);
    switch (RbacService.instance.config.cacheMedium) {
      case RbacCacheMedium.global:
        await session.caches.global.put(key, value, lifetime: lifetime);
        break;
      case RbacCacheMedium.local:
        await session.caches.local.put(key, value, lifetime: lifetime);
        break;
      case RbacCacheMedium.disabled:
        break;
    }
  }

  Future<String> _buildKey(Session session, String userIdentifier) async {
    final encodedUser = base64Url.encode(utf8.encode(userIdentifier));
    try {
      final distributedGeneration =
          await _readGeneration(session, 'serverpod_rbac:generation') ?? '0';
      final userGeneration =
          await _readGeneration(
            session,
            'serverpod_rbac:user-generation:$userIdentifier',
          ) ??
          '0';
      final processVersion =
          RbacService.instance.config.cacheMedium == RbacCacheMedium.global
          ? ''
          : 'v$_globalVersion:';
      return 'serverpod_rbac:${processVersion}g:$distributedGeneration:uv:$userGeneration:user:$encodedUser';
    } catch (error, stackTrace) {
      session.log(
        'Unable to read RBAC cache generations; using request-only cache: $error',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
      return 'serverpod_rbac:v$_globalVersion:request-only:${identityHashCode(session)}:user:$encodedUser';
    }
  }

  Future<RbacUserPermissionsInfo?> _getFromProcessCache(
    Session session,
    String key,
  ) async {
    return switch (RbacService.instance.config.cacheMedium) {
      RbacCacheMedium.global =>
        await session.caches.global.get<RbacUserPermissionsInfo>(key),
      RbacCacheMedium.local =>
        await session.caches.local.get<RbacUserPermissionsInfo>(key),
      RbacCacheMedium.disabled => null,
    };
  }

  Future<void> _putToProcessCache(
    Session session,
    String key,
    RbacUserPermissionsInfo info,
    Duration lifetime,
  ) async {
    switch (RbacService.instance.config.cacheMedium) {
      case RbacCacheMedium.global:
        await session.caches.global.put(key, info, lifetime: lifetime);
        break;
      case RbacCacheMedium.local:
        await session.caches.local.put(key, info, lifetime: lifetime);
        break;
      case RbacCacheMedium.disabled:
        break;
    }
  }

  /// Gets cached permissions for a user, if available.
  Future<RbacUserPermissionsInfo?> getUserPermissionsInfo(
    Session session,
    String userIdentifier,
  ) async {
    final key = await _buildKey(session, userIdentifier);
    final requestCache = _getSessionCache(session);
    if (RbacService.instance.config.enableRequestCache) {
      final cached = requestCache[key];
      if (cached is RbacUserPermissionsInfo) return cached;
    }

    if (RbacService.instance.config.cacheMedium != RbacCacheMedium.disabled) {
      try {
        final cached = await _getFromProcessCache(session, key);
        if (cached != null) {
          if (RbacService.instance.config.enableRequestCache) {
            requestCache[key] = cached;
          }
          return cached;
        }
      } catch (error, stackTrace) {
        session.log(
          'Unable to read RBAC permission cache; loading from database: $error',
          level: LogLevel.warning,
          exception: error,
          stackTrace: stackTrace,
        );
      }
    }
    return null;
  }

  /// Caches permissions for a user.
  Future<void> putUserPermissionsInfo(
    Session session,
    String userIdentifier,
    RbacUserPermissionsInfo info, {
    Duration? lifetime,
  }) async {
    final key = await _buildKey(session, userIdentifier);
    if (RbacService.instance.config.enableRequestCache) {
      _getSessionCache(session)[key] = info;
    }
    if (RbacService.instance.config.cacheMedium != RbacCacheMedium.disabled) {
      try {
        await _putToProcessCache(
          session,
          key,
          info,
          lifetime ?? defaultLifetime,
        );
      } catch (error, stackTrace) {
        session.log(
          'Unable to write RBAC permission cache: $error',
          level: LogLevel.warning,
          exception: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  /// Invalidates cached permissions for a specific user.
  Future<void> invalidateUser(Session session, String userIdentifier) async {
    final requestCache = _getSessionCache(session);
    requestCache.remove(
      'rbac-generation:serverpod_rbac:user-generation:$userIdentifier',
    );
    final encodedUser = base64Url.encode(utf8.encode(userIdentifier));
    requestCache.removeWhere(
      (key, _) => key.contains(':user:$encodedUser'),
    );
    if (RbacService.instance.config.cacheMedium == RbacCacheMedium.disabled) {
      return;
    }
    await _writeGeneration(
      session,
      'serverpod_rbac:user-generation:$userIdentifier',
      DateTime.now().microsecondsSinceEpoch.toString(),
    );
  }

  /// Invalidates all cached RBAC permissions across all users.
  Future<void> invalidateAll(Session session) async {
    _globalVersion++;
    _getSessionCache(session).clear();
    if (RbacService.instance.config.cacheMedium == RbacCacheMedium.disabled) {
      return;
    }
    await _writeGeneration(
      session,
      'serverpod_rbac:generation',
      DateTime.now().microsecondsSinceEpoch.toString(),
    );
  }
}
