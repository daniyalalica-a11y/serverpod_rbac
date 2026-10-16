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

abstract class RbacUserPermission
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isGranted']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = RbacUserPermissionTable();

  static const db = RbacUserPermissionRepository._();

  @override
  int? id;

  String userIdentifier;

  int permissionId;

  bool isGranted;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RbacUserPermission]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static RbacUserPermissionInclude include() {
    return RbacUserPermissionInclude._();
  }

  static RbacUserPermissionIncludeList includeList({
    _is.WhereExpressionBuilder<RbacUserPermissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacUserPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacUserPermissionTable>? orderByList,
    RbacUserPermissionInclude? include,
  }) {
    return RbacUserPermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacUserPermission.t),
      orderByList: orderByList?.call(RbacUserPermission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class RbacUserPermissionUpdateTable
    extends _is.UpdateTable<RbacUserPermissionTable> {
  RbacUserPermissionUpdateTable(super.table);

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<int, int> permissionId(int value) => _is.ColumnValue(
    table.permissionId,
    value,
  );

  _is.ColumnValue<bool, bool> isGranted(bool value) => _is.ColumnValue(
    table.isGranted,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class RbacUserPermissionTable extends _is.Table<int?> {
  RbacUserPermissionTable({super.tableRelation})
    : super(tableName: 'serverpod_rbac_user_permission') {
    updateTable = RbacUserPermissionUpdateTable(this);
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    permissionId = _is.ColumnInt(
      'permissionId',
      this,
    );
    isGranted = _is.ColumnBool(
      'isGranted',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final RbacUserPermissionUpdateTable updateTable;

  late final _is.ColumnString userIdentifier;

  late final _is.ColumnInt permissionId;

  late final _is.ColumnBool isGranted;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userIdentifier,
    permissionId,
    isGranted,
    createdAt,
  ];
}

class RbacUserPermissionInclude extends _is.IncludeObject {
  RbacUserPermissionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => RbacUserPermission.t;
}

class RbacUserPermissionIncludeList extends _is.IncludeList {
  RbacUserPermissionIncludeList._({
    _is.WhereExpressionBuilder<RbacUserPermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RbacUserPermission.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RbacUserPermission.t;
}

class RbacUserPermissionRepository {
  const RbacUserPermissionRepository._();

  /// Returns a list of [RbacUserPermission]s matching the given query parameters.
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
  Future<List<RbacUserPermission>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacUserPermissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacUserPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacUserPermissionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RbacUserPermission>(
      where: where?.call(RbacUserPermission.t),
      orderBy: orderBy?.call(RbacUserPermission.t),
      orderByList: orderByList?.call(RbacUserPermission.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RbacUserPermission] matching the given query parameters.
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
  Future<RbacUserPermission?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacUserPermissionTable>? where,
    int? offset,
    _is.OrderByBuilder<RbacUserPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacUserPermissionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RbacUserPermission>(
      where: where?.call(RbacUserPermission.t),
      orderBy: orderBy?.call(RbacUserPermission.t),
      orderByList: orderByList?.call(RbacUserPermission.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RbacUserPermission] by its [id] or null if no such row exists.
  Future<RbacUserPermission?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RbacUserPermission>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RbacUserPermission]s in the list and returns the inserted rows.
  ///
  /// The returned [RbacUserPermission]s will have their `id` fields set.
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
  Future<List<RbacUserPermission>> insert(
    _is.DatabaseSession session,
    List<RbacUserPermission> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RbacUserPermission>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RbacUserPermission] and returns the inserted row.
  ///
  /// The returned [RbacUserPermission] will have its `id` field set.
  Future<RbacUserPermission> insertRow(
    _is.DatabaseSession session,
    RbacUserPermission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RbacUserPermission>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RbacUserPermission]s in the list and returns the resulting rows.
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
  /// The returned [RbacUserPermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacUserPermission>> upsert(
    _is.DatabaseSession session,
    List<RbacUserPermission> rows, {
    required _is.ColumnSelections<RbacUserPermissionTable> conflictColumns,
    _is.ColumnSelections<RbacUserPermissionTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacUserPermissionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RbacUserPermission>(
      rows,
      conflictColumns: conflictColumns(RbacUserPermission.t),
      updateColumns: updateColumns?.call(RbacUserPermission.t),
      updateWhere: updateWhere?.call(RbacUserPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RbacUserPermission] and returns the resulting row.
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
  /// The returned [RbacUserPermission] will have its `id` field set.
  Future<RbacUserPermission?> upsertRow(
    _is.DatabaseSession session,
    RbacUserPermission row, {
    required _is.ColumnSelections<RbacUserPermissionTable> conflictColumns,
    _is.ColumnSelections<RbacUserPermissionTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacUserPermissionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RbacUserPermission>(
      row,
      conflictColumns: conflictColumns(RbacUserPermission.t),
      updateColumns: updateColumns?.call(RbacUserPermission.t),
      updateWhere: updateWhere?.call(RbacUserPermission.t),
      transaction: transaction,
    );
  }

  /// Updates all [RbacUserPermission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacUserPermission>> update(
    _is.DatabaseSession session,
    List<RbacUserPermission> rows, {
    _is.ColumnSelections<RbacUserPermissionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RbacUserPermission>(
      rows,
      columns: columns?.call(RbacUserPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RbacUserPermission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RbacUserPermission> updateRow(
    _is.DatabaseSession session,
    RbacUserPermission row, {
    _is.ColumnSelections<RbacUserPermissionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RbacUserPermission>(
      row,
      columns: columns?.call(RbacUserPermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RbacUserPermission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RbacUserPermission?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RbacUserPermissionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RbacUserPermission>(
      id,
      columnValues: columnValues(RbacUserPermission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RbacUserPermission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacUserPermission>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RbacUserPermissionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<RbacUserPermissionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacUserPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacUserPermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RbacUserPermission>(
      columnValues: columnValues(RbacUserPermission.t.updateTable),
      where: where(RbacUserPermission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacUserPermission.t),
      orderByList: orderByList?.call(RbacUserPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RbacUserPermission]s in the list and returns the deleted rows.
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
  Future<List<RbacUserPermission>> delete(
    _is.DatabaseSession session,
    List<RbacUserPermission> rows, {
    _is.OrderByBuilder<RbacUserPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacUserPermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RbacUserPermission>(
      rows,
      orderBy: orderBy?.call(RbacUserPermission.t),
      orderByList: orderByList?.call(RbacUserPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RbacUserPermission].
  Future<RbacUserPermission> deleteRow(
    _is.DatabaseSession session,
    RbacUserPermission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RbacUserPermission>(
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
  Future<List<RbacUserPermission>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacUserPermissionTable> where,
    _is.OrderByBuilder<RbacUserPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacUserPermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RbacUserPermission>(
      where: where(RbacUserPermission.t),
      orderBy: orderBy?.call(RbacUserPermission.t),
      orderByList: orderByList?.call(RbacUserPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacUserPermissionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RbacUserPermission>(
      where: where?.call(RbacUserPermission.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RbacUserPermission] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacUserPermissionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RbacUserPermission>(
      where: where(RbacUserPermission.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
