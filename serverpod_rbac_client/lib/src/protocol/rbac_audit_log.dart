/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class RbacAuditLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RbacAuditLog._({
    this.id,
    this.userIdentifier,
    required this.action,
    this.resource,
    this.permissionCodename,
    this.roleName,
    required this.allowed,
    this.details,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RbacAuditLog({
    int? id,
    String? userIdentifier,
    required String action,
    String? resource,
    String? permissionCodename,
    String? roleName,
    required bool allowed,
    String? details,
    DateTime? createdAt,
  }) = _RbacAuditLogImpl;

  factory RbacAuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacAuditLog(
      id: jsonSerialization['id'] as int?,
      userIdentifier: jsonSerialization['userIdentifier'] as String?,
      action: jsonSerialization['action'] as String,
      resource: jsonSerialization['resource'] as String?,
      permissionCodename: jsonSerialization['permissionCodename'] as String?,
      roleName: jsonSerialization['roleName'] as String?,
      allowed: _isc.BoolJsonExtension.fromJson(jsonSerialization['allowed']),
      details: jsonSerialization['details'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? userIdentifier;

  String action;

  String? resource;

  String? permissionCodename;

  String? roleName;

  bool allowed;

  String? details;

  DateTime createdAt;

  /// Returns a shallow copy of this [RbacAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RbacAuditLog copyWith({
    int? id,
    String? userIdentifier,
    String? action,
    String? resource,
    String? permissionCodename,
    String? roleName,
    bool? allowed,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacAuditLog',
      if (id != null) 'id': id,
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
      'action': action,
      if (resource != null) 'resource': resource,
      if (permissionCodename != null) 'permissionCodename': permissionCodename,
      if (roleName != null) 'roleName': roleName,
      'allowed': allowed,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacAuditLog',
      if (id != null) 'id': id,
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
      'action': action,
      if (resource != null) 'resource': resource,
      if (permissionCodename != null) 'permissionCodename': permissionCodename,
      if (roleName != null) 'roleName': roleName,
      'allowed': allowed,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacAuditLogImpl extends RbacAuditLog {
  _RbacAuditLogImpl({
    int? id,
    String? userIdentifier,
    required String action,
    String? resource,
    String? permissionCodename,
    String? roleName,
    required bool allowed,
    String? details,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userIdentifier: userIdentifier,
         action: action,
         resource: resource,
         permissionCodename: permissionCodename,
         roleName: roleName,
         allowed: allowed,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RbacAuditLog copyWith({
    Object? id = _Undefined,
    Object? userIdentifier = _Undefined,
    String? action,
    Object? resource = _Undefined,
    Object? permissionCodename = _Undefined,
    Object? roleName = _Undefined,
    bool? allowed,
    Object? details = _Undefined,
    DateTime? createdAt,
  }) {
    return RbacAuditLog(
      id: id is int? ? id : this.id,
      userIdentifier: userIdentifier is String?
          ? userIdentifier
          : this.userIdentifier,
      action: action ?? this.action,
      resource: resource is String? ? resource : this.resource,
      permissionCodename: permissionCodename is String?
          ? permissionCodename
          : this.permissionCodename,
      roleName: roleName is String? ? roleName : this.roleName,
      allowed: allowed ?? this.allowed,
      details: details is String? ? details : this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
