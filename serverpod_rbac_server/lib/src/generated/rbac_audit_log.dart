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

abstract class RbacAuditLog
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      allowed: _is.BoolJsonExtension.fromJson(jsonSerialization['allowed']),
      details: jsonSerialization['details'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = RbacAuditLogTable();

  static const db = RbacAuditLogRepository._();

  @override
  int? id;

  String? userIdentifier;

  String action;

  String? resource;

  String? permissionCodename;

  String? roleName;

  bool allowed;

  String? details;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RbacAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static RbacAuditLogInclude include() {
    return RbacAuditLogInclude._();
  }

  static RbacAuditLogIncludeList includeList({
    _is.WhereExpressionBuilder<RbacAuditLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacAuditLogTable>? orderBy,
    _is.OrderByListBuilder<RbacAuditLogTable>? orderByList,
    RbacAuditLogInclude? include,
  }) {
    return RbacAuditLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacAuditLog.t),
      orderByList: orderByList?.call(RbacAuditLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class RbacAuditLogUpdateTable extends _is.UpdateTable<RbacAuditLogTable> {
  RbacAuditLogUpdateTable(super.table);

  _is.ColumnValue<String, String> userIdentifier(String? value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<String, String> action(String value) => _is.ColumnValue(
    table.action,
    value,
  );

  _is.ColumnValue<String, String> resource(String? value) => _is.ColumnValue(
    table.resource,
    value,
  );

  _is.ColumnValue<String, String> permissionCodename(String? value) =>
      _is.ColumnValue(
        table.permissionCodename,
        value,
      );

  _is.ColumnValue<String, String> roleName(String? value) => _is.ColumnValue(
    table.roleName,
    value,
  );

  _is.ColumnValue<bool, bool> allowed(bool value) => _is.ColumnValue(
    table.allowed,
    value,
  );

  _is.ColumnValue<String, String> details(String? value) => _is.ColumnValue(
    table.details,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class RbacAuditLogTable extends _is.Table<int?> {
  RbacAuditLogTable({super.tableRelation})
    : super(tableName: 'serverpod_rbac_audit_log') {
    updateTable = RbacAuditLogUpdateTable(this);
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    action = _is.ColumnString(
      'action',
      this,
    );
    resource = _is.ColumnString(
      'resource',
      this,
    );
    permissionCodename = _is.ColumnString(
      'permissionCodename',
      this,
    );
    roleName = _is.ColumnString(
      'roleName',
      this,
    );
    allowed = _is.ColumnBool(
      'allowed',
      this,
    );
    details = _is.ColumnString(
      'details',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final RbacAuditLogUpdateTable updateTable;

  late final _is.ColumnString userIdentifier;

  late final _is.ColumnString action;

  late final _is.ColumnString resource;

  late final _is.ColumnString permissionCodename;

  late final _is.ColumnString roleName;

  late final _is.ColumnBool allowed;

  late final _is.ColumnString details;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userIdentifier,
    action,
    resource,
    permissionCodename,
    roleName,
    allowed,
    details,
    createdAt,
  ];
}

class RbacAuditLogInclude extends _is.IncludeObject {
  RbacAuditLogInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => RbacAuditLog.t;
}

class RbacAuditLogIncludeList extends _is.IncludeList {
  RbacAuditLogIncludeList._({
    _is.WhereExpressionBuilder<RbacAuditLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RbacAuditLog.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RbacAuditLog.t;
}

class RbacAuditLogRepository {
  const RbacAuditLogRepository._();

  /// Returns a list of [RbacAuditLog]s matching the given query parameters.
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
  Future<List<RbacAuditLog>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacAuditLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacAuditLogTable>? orderBy,
    _is.OrderByListBuilder<RbacAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RbacAuditLog>(
      where: where?.call(RbacAuditLog.t),
      orderBy: orderBy?.call(RbacAuditLog.t),
      orderByList: orderByList?.call(RbacAuditLog.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RbacAuditLog] matching the given query parameters.
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
  Future<RbacAuditLog?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacAuditLogTable>? where,
    int? offset,
    _is.OrderByBuilder<RbacAuditLogTable>? orderBy,
    _is.OrderByListBuilder<RbacAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RbacAuditLog>(
      where: where?.call(RbacAuditLog.t),
      orderBy: orderBy?.call(RbacAuditLog.t),
      orderByList: orderByList?.call(RbacAuditLog.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RbacAuditLog] by its [id] or null if no such row exists.
  Future<RbacAuditLog?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RbacAuditLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RbacAuditLog]s in the list and returns the inserted rows.
  ///
  /// The returned [RbacAuditLog]s will have their `id` fields set.
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
  Future<List<RbacAuditLog>> insert(
    _is.DatabaseSession session,
    List<RbacAuditLog> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RbacAuditLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RbacAuditLog] and returns the inserted row.
  ///
  /// The returned [RbacAuditLog] will have its `id` field set.
  Future<RbacAuditLog> insertRow(
    _is.DatabaseSession session,
    RbacAuditLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RbacAuditLog>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RbacAuditLog]s in the list and returns the resulting rows.
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
  /// The returned [RbacAuditLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacAuditLog>> upsert(
    _is.DatabaseSession session,
    List<RbacAuditLog> rows, {
    required _is.ColumnSelections<RbacAuditLogTable> conflictColumns,
    _is.ColumnSelections<RbacAuditLogTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacAuditLogTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RbacAuditLog>(
      rows,
      conflictColumns: conflictColumns(RbacAuditLog.t),
      updateColumns: updateColumns?.call(RbacAuditLog.t),
      updateWhere: updateWhere?.call(RbacAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RbacAuditLog] and returns the resulting row.
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
  /// The returned [RbacAuditLog] will have its `id` field set.
  Future<RbacAuditLog?> upsertRow(
    _is.DatabaseSession session,
    RbacAuditLog row, {
    required _is.ColumnSelections<RbacAuditLogTable> conflictColumns,
    _is.ColumnSelections<RbacAuditLogTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacAuditLogTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RbacAuditLog>(
      row,
      conflictColumns: conflictColumns(RbacAuditLog.t),
      updateColumns: updateColumns?.call(RbacAuditLog.t),
      updateWhere: updateWhere?.call(RbacAuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates all [RbacAuditLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacAuditLog>> update(
    _is.DatabaseSession session,
    List<RbacAuditLog> rows, {
    _is.ColumnSelections<RbacAuditLogTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RbacAuditLog>(
      rows,
      columns: columns?.call(RbacAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RbacAuditLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RbacAuditLog> updateRow(
    _is.DatabaseSession session,
    RbacAuditLog row, {
    _is.ColumnSelections<RbacAuditLogTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RbacAuditLog>(
      row,
      columns: columns?.call(RbacAuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RbacAuditLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RbacAuditLog?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RbacAuditLogUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RbacAuditLog>(
      id,
      columnValues: columnValues(RbacAuditLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RbacAuditLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacAuditLog>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RbacAuditLogUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RbacAuditLogTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacAuditLogTable>? orderBy,
    _is.OrderByListBuilder<RbacAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RbacAuditLog>(
      columnValues: columnValues(RbacAuditLog.t.updateTable),
      where: where(RbacAuditLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacAuditLog.t),
      orderByList: orderByList?.call(RbacAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RbacAuditLog]s in the list and returns the deleted rows.
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
  Future<List<RbacAuditLog>> delete(
    _is.DatabaseSession session,
    List<RbacAuditLog> rows, {
    _is.OrderByBuilder<RbacAuditLogTable>? orderBy,
    _is.OrderByListBuilder<RbacAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RbacAuditLog>(
      rows,
      orderBy: orderBy?.call(RbacAuditLog.t),
      orderByList: orderByList?.call(RbacAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RbacAuditLog].
  Future<RbacAuditLog> deleteRow(
    _is.DatabaseSession session,
    RbacAuditLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RbacAuditLog>(
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
  Future<List<RbacAuditLog>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacAuditLogTable> where,
    _is.OrderByBuilder<RbacAuditLogTable>? orderBy,
    _is.OrderByListBuilder<RbacAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RbacAuditLog>(
      where: where(RbacAuditLog.t),
      orderBy: orderBy?.call(RbacAuditLog.t),
      orderByList: orderByList?.call(RbacAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacAuditLogTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RbacAuditLog>(
      where: where?.call(RbacAuditLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RbacAuditLog] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacAuditLogTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RbacAuditLog>(
      where: where(RbacAuditLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
