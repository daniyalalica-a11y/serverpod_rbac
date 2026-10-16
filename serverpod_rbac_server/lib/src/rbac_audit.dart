import 'package:serverpod/serverpod.dart';
import 'generated/protocol.dart';

import 'rbac_service.dart';

/// Service responsible for recording RBAC audit trail entries.
class RbacAuditService {
  /// Whether audit logging is enabled.
  bool get isEnabled => RbacService.instance.config.enableAuditLog;
  set isEnabled(bool value) =>
      RbacService.instance.config.enableAuditLog = value;

  /// Log an authorization decision or administrative action.
  Future<void> log(
    Session session, {
    String? userIdentifier,
    required String action,
    String? resource,
    String? permissionCodename,
    String? roleName,
    required bool allowed,
    String? details,
  }) async {
    if (!isEnabled) return;

    try {
      final logEntry = RbacAuditLog(
        userIdentifier: userIdentifier,
        action: action,
        resource: resource,
        permissionCodename: permissionCodename,
        roleName: roleName,
        allowed: allowed,
        details: details,
        createdAt: DateTime.now(),
      );
      await RbacAuditLog.db.insertRow(session, logEntry);
    } catch (e, st) {
      session.log(
        'Failed to write RBAC audit log: $e',
        level: LogLevel.warning,
        exception: e,
        stackTrace: st,
      );
    }
  }

  /// Writes a batch of audit events in one database operation.
  Future<void> logMany(Session session, List<RbacAuditLog> entries) async {
    if (!isEnabled || entries.isEmpty) return;

    try {
      await RbacAuditLog.db.insert(session, entries, noReturn: true);
    } catch (e, st) {
      session.log(
        'Failed to write RBAC audit logs: $e',
        level: LogLevel.warning,
        exception: e,
        stackTrace: st,
      );
    }
  }
}
