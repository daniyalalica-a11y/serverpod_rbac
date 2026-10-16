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

abstract class RbacPermission
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RbacPermission._({
    this.id,
    required this.resource,
    required this.codename,
    required this.name,
    this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RbacPermission({
    int? id,
    required String resource,
    required String codename,
    required String name,
    String? description,
    DateTime? createdAt,
  }) = _RbacPermissionImpl;

  factory RbacPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacPermission(
      id: jsonSerialization['id'] as int?,
      resource: jsonSerialization['resource'] as String,
      codename: jsonSerialization['codename'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String resource;

  String codename;

  String name;

  String? description;

  DateTime createdAt;

  /// Returns a shallow copy of this [RbacPermission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RbacPermission copyWith({
    int? id,
    String? resource,
    String? codename,
    String? name,
    String? description,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacPermission',
      if (id != null) 'id': id,
      'resource': resource,
      'codename': codename,
      'name': name,
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacPermission',
      if (id != null) 'id': id,
      'resource': resource,
      'codename': codename,
      'name': name,
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacPermissionImpl extends RbacPermission {
  _RbacPermissionImpl({
    int? id,
    required String resource,
    required String codename,
    required String name,
    String? description,
    DateTime? createdAt,
  }) : super._(
         id: id,
         resource: resource,
         codename: codename,
         name: name,
         description: description,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacPermission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RbacPermission copyWith({
    Object? id = _Undefined,
    String? resource,
    String? codename,
    String? name,
    Object? description = _Undefined,
    DateTime? createdAt,
  }) {
    return RbacPermission(
      id: id is int? ? id : this.id,
      resource: resource ?? this.resource,
      codename: codename ?? this.codename,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
