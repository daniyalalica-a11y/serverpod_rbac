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

abstract class RbacUserPermission
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RbacUserPermission._({
    this.id,
    required this.userIdentifier,
    required this.permissionId,
    bool? isGranted,
    DateTime? createdAt,
  }) : isGranted = isGranted ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory RbacUserPermission({
    int? id,
    required String userIdentifier,
    required int permissionId,
    bool? isGranted,
    DateTime? createdAt,
  }) = _RbacUserPermissionImpl;

  factory RbacUserPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacUserPermission(
      id: jsonSerialization['id'] as int?,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      permissionId: jsonSerialization['permissionId'] as int,
      isGranted: jsonSerialization['isGranted'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isGranted']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userIdentifier;

  int permissionId;

  bool isGranted;

  DateTime createdAt;

  /// Returns a shallow copy of this [RbacUserPermission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RbacUserPermission copyWith({
    int? id,
    String? userIdentifier,
    int? permissionId,
    bool? isGranted,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacUserPermission',
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      'permissionId': permissionId,
      'isGranted': isGranted,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacUserPermission',
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      'permissionId': permissionId,
      'isGranted': isGranted,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacUserPermissionImpl extends RbacUserPermission {
  _RbacUserPermissionImpl({
    int? id,
    required String userIdentifier,
    required int permissionId,
    bool? isGranted,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userIdentifier: userIdentifier,
         permissionId: permissionId,
         isGranted: isGranted,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacUserPermission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RbacUserPermission copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    int? permissionId,
    bool? isGranted,
    DateTime? createdAt,
  }) {
    return RbacUserPermission(
      id: id is int? ? id : this.id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      permissionId: permissionId ?? this.permissionId,
      isGranted: isGranted ?? this.isGranted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
