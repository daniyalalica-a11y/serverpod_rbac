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
import 'package:serverpod/serverpod.dart' as _is;

abstract class RbacRolePermission
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RbacRolePermission._({
    this.id,
    required this.roleId,
    required this.permissionId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RbacRolePermission({
    int? id,
    required int roleId,
    required int permissionId,
    DateTime? createdAt,
  }) = _RbacRolePermissionImpl;

  factory RbacRolePermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacRolePermission(
      id: jsonSerialization['id'] as int?,
      roleId: jsonSerialization['roleId'] as int,
      permissionId: jsonSerialization['permissionId'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = RbacRolePermissionTable();

  static const db = RbacRolePermissionRepository._();

  @override
  int? id;

  int roleId;

  int permissionId;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RbacRolePermission]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RbacRolePermission copyWith({
    int? id,
    int? roleId,
    int? permissionId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacRolePermission',
      if (id != null) 'id': id,
      'roleId': roleId,
      'permissionId': permissionId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacRolePermission',
      if (id != null) 'id': id,
      'roleId': roleId,
      'permissionId': permissionId,
      'createdAt': createdAt.toJson(),
    };
  }

  static RbacRolePermissionInclude include() {
    return RbacRolePermissionInclude._();
  }

  static RbacRolePermissionIncludeList includeList({
    _is.WhereExpressionBuilder<RbacRolePermissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacRolePermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacRolePermissionTable>? orderByList,
    RbacRolePermissionInclude? include,
  }) {
    return RbacRolePermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacRolePermission.t),
      orderByList: orderByList?.call(RbacRolePermission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacRolePermissionImpl extends RbacRolePermission {
  _RbacRolePermissionImpl({
    int? id,
    required int roleId,
    required int permissionId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         roleId: roleId,
         permissionId: permissionId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacRolePermission]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RbacRolePermission copyWith({
    Object? id = _Undefined,
    int? roleId,
    int? permissionId,
    DateTime? createdAt,
  }) {
    return RbacRolePermission(
      id: id is int? ? id : this.id,
      roleId: roleId ?? this.roleId,
      permissionId: permissionId ?? this.permissionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RbacRolePermissionUpdateTable
    extends _is.UpdateTable<RbacRolePermissionTable> {
  RbacRolePermissionUpdateTable(super.table);

  _is.ColumnValue<int, int> roleId(int value) => _is.ColumnValue(
    table.roleId,
    value,
  );

  _is.ColumnValue<int, int> permissionId(int value) => _is.ColumnValue(
    table.permissionId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class RbacRolePermissionTable extends _is.Table<int?> {
  RbacRolePermissionTable({super.tableRelation})
    : super(tableName: 'serverpod_rbac_role_permission') {
    updateTable = RbacRolePermissionUpdateTable(this);
    roleId = _is.ColumnInt(
      'roleId',
      this,
    );
    permissionId = _is.ColumnInt(
      'permissionId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final RbacRolePermissionUpdateTable updateTable;

  late final _is.ColumnInt roleId;

  late final _is.ColumnInt permissionId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    roleId,
    permissionId,
    createdAt,
  ];
}

class RbacRolePermissionInclude extends _is.IncludeObject {
  RbacRolePermissionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => RbacRolePermission.t;
}

class RbacRolePermissionIncludeList extends _is.IncludeList {
  RbacRolePermissionIncludeList._({
    _is.WhereExpressionBuilder<RbacRolePermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RbacRolePermission.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RbacRolePermission.t;
}

class RbacRolePermissionRepository {
  const RbacRolePermissionRepository._();

  /// Returns a list of [RbacRolePermission]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<RbacRolePermission>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacRolePermissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacRolePermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacRolePermissionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RbacRolePermission>(
      where: where?.call(RbacRolePermission.t),
      orderBy: orderBy?.call(RbacRolePermission.t),
      orderByList: orderByList?.call(RbacRolePermission.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RbacRolePermission] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<RbacRolePermission?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacRolePermissionTable>? where,
    int? offset,
    _is.OrderByBuilder<RbacRolePermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacRolePermissionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RbacRolePermission>(
      where: where?.call(RbacRolePermission.t),
      orderBy: orderBy?.call(RbacRolePermission.t),
      orderByList: orderByList?.call(RbacRolePermission.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RbacRolePermission] by its [id] or null if no such row exists.
  Future<RbacRolePermission?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RbacRolePermission>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RbacRolePermission]s in the list and returns the inserted rows.
  ///
  /// The returned [RbacRolePermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRolePermission>> insert(
    _is.DatabaseSession session,
    List<RbacRolePermission> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RbacRolePermission>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RbacRolePermission] and returns the inserted row.
  ///
  /// The returned [RbacRolePermission] will have its `id` field set.
  Future<RbacRolePermission> insertRow(
    _is.DatabaseSession session,
    RbacRolePermission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RbacRolePermission>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RbacRolePermission]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [RbacRolePermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRolePermission>> upsert(
    _is.DatabaseSession session,
    List<RbacRolePermission> rows, {
    required _is.ColumnSelections<RbacRolePermissionTable> conflictColumns,
    _is.ColumnSelections<RbacRolePermissionTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacRolePermissionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RbacRolePermission>(
      rows,
      conflictColumns: conflictColumns(RbacRolePermission.t),
      updateColumns: updateColumns?.call(RbacRolePermission.t),
      updateWhere: updateWhere?.call(RbacRolePermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RbacRolePermission] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [RbacRolePermission] will have its `id` field set.
  Future<RbacRolePermission?> upsertRow(
    _is.DatabaseSession session,
    RbacRolePermission row, {
    required _is.ColumnSelections<RbacRolePermissionTable> conflictColumns,
    _is.ColumnSelections<RbacRolePermissionTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacRolePermissionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RbacRolePermission>(
      row,
      conflictColumns: conflictColumns(RbacRolePermission.t),
      updateColumns: updateColumns?.call(RbacRolePermission.t),
      updateWhere: updateWhere?.call(RbacRolePermission.t),
      transaction: transaction,
    );
  }

  /// Updates all [RbacRolePermission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRolePermission>> update(
    _is.DatabaseSession session,
    List<RbacRolePermission> rows, {
    _is.ColumnSelections<RbacRolePermissionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RbacRolePermission>(
      rows,
      columns: columns?.call(RbacRolePermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RbacRolePermission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RbacRolePermission> updateRow(
    _is.DatabaseSession session,
    RbacRolePermission row, {
    _is.ColumnSelections<RbacRolePermissionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RbacRolePermission>(
      row,
      columns: columns?.call(RbacRolePermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RbacRolePermission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RbacRolePermission?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RbacRolePermissionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RbacRolePermission>(
      id,
      columnValues: columnValues(RbacRolePermission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RbacRolePermission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRolePermission>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RbacRolePermissionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<RbacRolePermissionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacRolePermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacRolePermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RbacRolePermission>(
      columnValues: columnValues(RbacRolePermission.t.updateTable),
      where: where(RbacRolePermission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacRolePermission.t),
      orderByList: orderByList?.call(RbacRolePermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RbacRolePermission]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRolePermission>> delete(
    _is.DatabaseSession session,
    List<RbacRolePermission> rows, {
    _is.OrderByBuilder<RbacRolePermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacRolePermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RbacRolePermission>(
      rows,
      orderBy: orderBy?.call(RbacRolePermission.t),
      orderByList: orderByList?.call(RbacRolePermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RbacRolePermission].
  Future<RbacRolePermission> deleteRow(
    _is.DatabaseSession session,
    RbacRolePermission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RbacRolePermission>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRolePermission>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacRolePermissionTable> where,
    _is.OrderByBuilder<RbacRolePermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacRolePermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RbacRolePermission>(
      where: where(RbacRolePermission.t),
      orderBy: orderBy?.call(RbacRolePermission.t),
      orderByList: orderByList?.call(RbacRolePermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacRolePermissionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RbacRolePermission>(
      where: where?.call(RbacRolePermission.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RbacRolePermission] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacRolePermissionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RbacRolePermission>(
      where: where(RbacRolePermission.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
