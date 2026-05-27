// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repforge_database.dart';

// ignore_for_file: type=lint
class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workoutSetIdMeta = const VerificationMeta(
    'workoutSetId',
  );
  @override
  late final GeneratedColumn<String> workoutSetId = GeneratedColumn<String>(
    'workout_set_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(workout_set_id) > 0)',
  );
  static const VerificationMeta _exerciseSourceMeta = const VerificationMeta(
    'exerciseSource',
  );
  @override
  late final GeneratedColumn<String> exerciseSource = GeneratedColumn<String>(
    'exercise_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (exercise_source IN (\'official\', \'custom\'))',
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(exercise_id) > 0)',
  );
  static const VerificationMeta _exerciseDisplayNameSnapshotMeta =
      const VerificationMeta('exerciseDisplayNameSnapshot');
  @override
  late final GeneratedColumn<String> exerciseDisplayNameSnapshot =
      GeneratedColumn<String>(
        'exercise_display_name_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        $customConstraints:
            'NOT NULL CHECK (length(exercise_display_name_snapshot) > 0)',
      );
  static const VerificationMeta _catalogVersionSnapshotMeta =
      const VerificationMeta('catalogVersionSnapshot');
  @override
  late final GeneratedColumn<String>
  catalogVersionSnapshot = GeneratedColumn<String>(
    'catalog_version_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NULL CHECK (catalog_version_snapshot IS NULL OR length(catalog_version_snapshot) > 0)',
  );
  static const VerificationMeta _workoutSessionIdMeta = const VerificationMeta(
    'workoutSessionId',
  );
  @override
  late final GeneratedColumn<String> workoutSessionId = GeneratedColumn<String>(
    'workout_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NULL CHECK (workout_session_id IS NULL OR length(workout_session_id) > 0)',
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (repetitions > 0)',
  );
  static const VerificationMeta _loadKgMeta = const VerificationMeta('loadKg');
  @override
  late final GeneratedColumn<double> loadKg = GeneratedColumn<double>(
    'load_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (load_kg >= 0)',
  );
  static const VerificationMeta _performedAtMeta = const VerificationMeta(
    'performedAt',
  );
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
    'performed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL CHECK (comment IS NULL OR length(comment) > 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    workoutSetId,
    exerciseSource,
    exerciseId,
    exerciseDisplayNameSnapshot,
    catalogVersionSnapshot,
    workoutSessionId,
    repetitions,
    loadKg,
    performedAt,
    comment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('workout_set_id')) {
      context.handle(
        _workoutSetIdMeta,
        workoutSetId.isAcceptableOrUnknown(
          data['workout_set_id']!,
          _workoutSetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutSetIdMeta);
    }
    if (data.containsKey('exercise_source')) {
      context.handle(
        _exerciseSourceMeta,
        exerciseSource.isAcceptableOrUnknown(
          data['exercise_source']!,
          _exerciseSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseSourceMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('exercise_display_name_snapshot')) {
      context.handle(
        _exerciseDisplayNameSnapshotMeta,
        exerciseDisplayNameSnapshot.isAcceptableOrUnknown(
          data['exercise_display_name_snapshot']!,
          _exerciseDisplayNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseDisplayNameSnapshotMeta);
    }
    if (data.containsKey('catalog_version_snapshot')) {
      context.handle(
        _catalogVersionSnapshotMeta,
        catalogVersionSnapshot.isAcceptableOrUnknown(
          data['catalog_version_snapshot']!,
          _catalogVersionSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('workout_session_id')) {
      context.handle(
        _workoutSessionIdMeta,
        workoutSessionId.isAcceptableOrUnknown(
          data['workout_session_id']!,
          _workoutSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repetitionsMeta);
    }
    if (data.containsKey('load_kg')) {
      context.handle(
        _loadKgMeta,
        loadKg.isAcceptableOrUnknown(data['load_kg']!, _loadKgMeta),
      );
    } else if (isInserting) {
      context.missing(_loadKgMeta);
    }
    if (data.containsKey('performed_at')) {
      context.handle(
        _performedAtMeta,
        performedAt.isAcceptableOrUnknown(
          data['performed_at']!,
          _performedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workoutSetId};
  @override
  WorkoutSetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetRow(
      workoutSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_set_id'],
      )!,
      exerciseSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_source'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      exerciseDisplayNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_display_name_snapshot'],
      )!,
      catalogVersionSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_version_snapshot'],
      ),
      workoutSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_session_id'],
      ),
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      loadKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}load_kg'],
      )!,
      performedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performed_at'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSetRow extends DataClass implements Insertable<WorkoutSetRow> {
  final String workoutSetId;
  final String exerciseSource;
  final String exerciseId;
  final String exerciseDisplayNameSnapshot;
  final String? catalogVersionSnapshot;
  final String? workoutSessionId;
  final int repetitions;
  final double loadKg;
  final DateTime performedAt;
  final String? comment;
  const WorkoutSetRow({
    required this.workoutSetId,
    required this.exerciseSource,
    required this.exerciseId,
    required this.exerciseDisplayNameSnapshot,
    this.catalogVersionSnapshot,
    this.workoutSessionId,
    required this.repetitions,
    required this.loadKg,
    required this.performedAt,
    this.comment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workout_set_id'] = Variable<String>(workoutSetId);
    map['exercise_source'] = Variable<String>(exerciseSource);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['exercise_display_name_snapshot'] = Variable<String>(
      exerciseDisplayNameSnapshot,
    );
    if (!nullToAbsent || catalogVersionSnapshot != null) {
      map['catalog_version_snapshot'] = Variable<String>(
        catalogVersionSnapshot,
      );
    }
    if (!nullToAbsent || workoutSessionId != null) {
      map['workout_session_id'] = Variable<String>(workoutSessionId);
    }
    map['repetitions'] = Variable<int>(repetitions);
    map['load_kg'] = Variable<double>(loadKg);
    map['performed_at'] = Variable<DateTime>(performedAt);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      workoutSetId: Value(workoutSetId),
      exerciseSource: Value(exerciseSource),
      exerciseId: Value(exerciseId),
      exerciseDisplayNameSnapshot: Value(exerciseDisplayNameSnapshot),
      catalogVersionSnapshot: catalogVersionSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogVersionSnapshot),
      workoutSessionId: workoutSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutSessionId),
      repetitions: Value(repetitions),
      loadKg: Value(loadKg),
      performedAt: Value(performedAt),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory WorkoutSetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetRow(
      workoutSetId: serializer.fromJson<String>(json['workoutSetId']),
      exerciseSource: serializer.fromJson<String>(json['exerciseSource']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      exerciseDisplayNameSnapshot: serializer.fromJson<String>(
        json['exerciseDisplayNameSnapshot'],
      ),
      catalogVersionSnapshot: serializer.fromJson<String?>(
        json['catalogVersionSnapshot'],
      ),
      workoutSessionId: serializer.fromJson<String?>(json['workoutSessionId']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      loadKg: serializer.fromJson<double>(json['loadKg']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workoutSetId': serializer.toJson<String>(workoutSetId),
      'exerciseSource': serializer.toJson<String>(exerciseSource),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'exerciseDisplayNameSnapshot': serializer.toJson<String>(
        exerciseDisplayNameSnapshot,
      ),
      'catalogVersionSnapshot': serializer.toJson<String?>(
        catalogVersionSnapshot,
      ),
      'workoutSessionId': serializer.toJson<String?>(workoutSessionId),
      'repetitions': serializer.toJson<int>(repetitions),
      'loadKg': serializer.toJson<double>(loadKg),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  WorkoutSetRow copyWith({
    String? workoutSetId,
    String? exerciseSource,
    String? exerciseId,
    String? exerciseDisplayNameSnapshot,
    Value<String?> catalogVersionSnapshot = const Value.absent(),
    Value<String?> workoutSessionId = const Value.absent(),
    int? repetitions,
    double? loadKg,
    DateTime? performedAt,
    Value<String?> comment = const Value.absent(),
  }) => WorkoutSetRow(
    workoutSetId: workoutSetId ?? this.workoutSetId,
    exerciseSource: exerciseSource ?? this.exerciseSource,
    exerciseId: exerciseId ?? this.exerciseId,
    exerciseDisplayNameSnapshot:
        exerciseDisplayNameSnapshot ?? this.exerciseDisplayNameSnapshot,
    catalogVersionSnapshot: catalogVersionSnapshot.present
        ? catalogVersionSnapshot.value
        : this.catalogVersionSnapshot,
    workoutSessionId: workoutSessionId.present
        ? workoutSessionId.value
        : this.workoutSessionId,
    repetitions: repetitions ?? this.repetitions,
    loadKg: loadKg ?? this.loadKg,
    performedAt: performedAt ?? this.performedAt,
    comment: comment.present ? comment.value : this.comment,
  );
  WorkoutSetRow copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSetRow(
      workoutSetId: data.workoutSetId.present
          ? data.workoutSetId.value
          : this.workoutSetId,
      exerciseSource: data.exerciseSource.present
          ? data.exerciseSource.value
          : this.exerciseSource,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      exerciseDisplayNameSnapshot: data.exerciseDisplayNameSnapshot.present
          ? data.exerciseDisplayNameSnapshot.value
          : this.exerciseDisplayNameSnapshot,
      catalogVersionSnapshot: data.catalogVersionSnapshot.present
          ? data.catalogVersionSnapshot.value
          : this.catalogVersionSnapshot,
      workoutSessionId: data.workoutSessionId.present
          ? data.workoutSessionId.value
          : this.workoutSessionId,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      loadKg: data.loadKg.present ? data.loadKg.value : this.loadKg,
      performedAt: data.performedAt.present
          ? data.performedAt.value
          : this.performedAt,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetRow(')
          ..write('workoutSetId: $workoutSetId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseDisplayNameSnapshot: $exerciseDisplayNameSnapshot, ')
          ..write('catalogVersionSnapshot: $catalogVersionSnapshot, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('repetitions: $repetitions, ')
          ..write('loadKg: $loadKg, ')
          ..write('performedAt: $performedAt, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    workoutSetId,
    exerciseSource,
    exerciseId,
    exerciseDisplayNameSnapshot,
    catalogVersionSnapshot,
    workoutSessionId,
    repetitions,
    loadKg,
    performedAt,
    comment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetRow &&
          other.workoutSetId == this.workoutSetId &&
          other.exerciseSource == this.exerciseSource &&
          other.exerciseId == this.exerciseId &&
          other.exerciseDisplayNameSnapshot ==
              this.exerciseDisplayNameSnapshot &&
          other.catalogVersionSnapshot == this.catalogVersionSnapshot &&
          other.workoutSessionId == this.workoutSessionId &&
          other.repetitions == this.repetitions &&
          other.loadKg == this.loadKg &&
          other.performedAt == this.performedAt &&
          other.comment == this.comment);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSetRow> {
  final Value<String> workoutSetId;
  final Value<String> exerciseSource;
  final Value<String> exerciseId;
  final Value<String> exerciseDisplayNameSnapshot;
  final Value<String?> catalogVersionSnapshot;
  final Value<String?> workoutSessionId;
  final Value<int> repetitions;
  final Value<double> loadKg;
  final Value<DateTime> performedAt;
  final Value<String?> comment;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.workoutSetId = const Value.absent(),
    this.exerciseSource = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.exerciseDisplayNameSnapshot = const Value.absent(),
    this.catalogVersionSnapshot = const Value.absent(),
    this.workoutSessionId = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.loadKg = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    required String workoutSetId,
    required String exerciseSource,
    required String exerciseId,
    required String exerciseDisplayNameSnapshot,
    this.catalogVersionSnapshot = const Value.absent(),
    this.workoutSessionId = const Value.absent(),
    required int repetitions,
    required double loadKg,
    required DateTime performedAt,
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : workoutSetId = Value(workoutSetId),
       exerciseSource = Value(exerciseSource),
       exerciseId = Value(exerciseId),
       exerciseDisplayNameSnapshot = Value(exerciseDisplayNameSnapshot),
       repetitions = Value(repetitions),
       loadKg = Value(loadKg),
       performedAt = Value(performedAt);
  static Insertable<WorkoutSetRow> custom({
    Expression<String>? workoutSetId,
    Expression<String>? exerciseSource,
    Expression<String>? exerciseId,
    Expression<String>? exerciseDisplayNameSnapshot,
    Expression<String>? catalogVersionSnapshot,
    Expression<String>? workoutSessionId,
    Expression<int>? repetitions,
    Expression<double>? loadKg,
    Expression<DateTime>? performedAt,
    Expression<String>? comment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workoutSetId != null) 'workout_set_id': workoutSetId,
      if (exerciseSource != null) 'exercise_source': exerciseSource,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (exerciseDisplayNameSnapshot != null)
        'exercise_display_name_snapshot': exerciseDisplayNameSnapshot,
      if (catalogVersionSnapshot != null)
        'catalog_version_snapshot': catalogVersionSnapshot,
      if (workoutSessionId != null) 'workout_session_id': workoutSessionId,
      if (repetitions != null) 'repetitions': repetitions,
      if (loadKg != null) 'load_kg': loadKg,
      if (performedAt != null) 'performed_at': performedAt,
      if (comment != null) 'comment': comment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<String>? workoutSetId,
    Value<String>? exerciseSource,
    Value<String>? exerciseId,
    Value<String>? exerciseDisplayNameSnapshot,
    Value<String?>? catalogVersionSnapshot,
    Value<String?>? workoutSessionId,
    Value<int>? repetitions,
    Value<double>? loadKg,
    Value<DateTime>? performedAt,
    Value<String?>? comment,
    Value<int>? rowid,
  }) {
    return WorkoutSetsCompanion(
      workoutSetId: workoutSetId ?? this.workoutSetId,
      exerciseSource: exerciseSource ?? this.exerciseSource,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseDisplayNameSnapshot:
          exerciseDisplayNameSnapshot ?? this.exerciseDisplayNameSnapshot,
      catalogVersionSnapshot:
          catalogVersionSnapshot ?? this.catalogVersionSnapshot,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      repetitions: repetitions ?? this.repetitions,
      loadKg: loadKg ?? this.loadKg,
      performedAt: performedAt ?? this.performedAt,
      comment: comment ?? this.comment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workoutSetId.present) {
      map['workout_set_id'] = Variable<String>(workoutSetId.value);
    }
    if (exerciseSource.present) {
      map['exercise_source'] = Variable<String>(exerciseSource.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (exerciseDisplayNameSnapshot.present) {
      map['exercise_display_name_snapshot'] = Variable<String>(
        exerciseDisplayNameSnapshot.value,
      );
    }
    if (catalogVersionSnapshot.present) {
      map['catalog_version_snapshot'] = Variable<String>(
        catalogVersionSnapshot.value,
      );
    }
    if (workoutSessionId.present) {
      map['workout_session_id'] = Variable<String>(workoutSessionId.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (loadKg.present) {
      map['load_kg'] = Variable<double>(loadKg.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('workoutSetId: $workoutSetId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseDisplayNameSnapshot: $exerciseDisplayNameSnapshot, ')
          ..write('catalogVersionSnapshot: $catalogVersionSnapshot, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('repetitions: $repetitions, ')
          ..write('loadKg: $loadKg, ')
          ..write('performedAt: $performedAt, ')
          ..write('comment: $comment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$RepForgeDatabase extends GeneratedDatabase {
  _$RepForgeDatabase(QueryExecutor e) : super(e);
  $RepForgeDatabaseManager get managers => $RepForgeDatabaseManager(this);
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [workoutSets];
}

typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      required String workoutSetId,
      required String exerciseSource,
      required String exerciseId,
      required String exerciseDisplayNameSnapshot,
      Value<String?> catalogVersionSnapshot,
      Value<String?> workoutSessionId,
      required int repetitions,
      required double loadKg,
      required DateTime performedAt,
      Value<String?> comment,
      Value<int> rowid,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> workoutSetId,
      Value<String> exerciseSource,
      Value<String> exerciseId,
      Value<String> exerciseDisplayNameSnapshot,
      Value<String?> catalogVersionSnapshot,
      Value<String?> workoutSessionId,
      Value<int> repetitions,
      Value<double> loadKg,
      Value<DateTime> performedAt,
      Value<String?> comment,
      Value<int> rowid,
    });

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$RepForgeDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get workoutSetId => $composableBuilder(
    column: $table.workoutSetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseDisplayNameSnapshot => $composableBuilder(
    column: $table.exerciseDisplayNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogVersionSnapshot => $composableBuilder(
    column: $table.catalogVersionSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutSessionId => $composableBuilder(
    column: $table.workoutSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loadKg => $composableBuilder(
    column: $table.loadKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$RepForgeDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get workoutSetId => $composableBuilder(
    column: $table.workoutSetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseDisplayNameSnapshot => $composableBuilder(
    column: $table.exerciseDisplayNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogVersionSnapshot => $composableBuilder(
    column: $table.catalogVersionSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutSessionId => $composableBuilder(
    column: $table.workoutSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loadKg => $composableBuilder(
    column: $table.loadKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$RepForgeDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get workoutSetId => $composableBuilder(
    column: $table.workoutSetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseDisplayNameSnapshot => $composableBuilder(
    column: $table.exerciseDisplayNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catalogVersionSnapshot => $composableBuilder(
    column: $table.catalogVersionSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workoutSessionId => $composableBuilder(
    column: $table.workoutSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get loadKg =>
      $composableBuilder(column: $table.loadKg, builder: (column) => column);

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $WorkoutSetsTable,
          WorkoutSetRow,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (
            WorkoutSetRow,
            BaseReferences<
              _$RepForgeDatabase,
              $WorkoutSetsTable,
              WorkoutSetRow
            >,
          ),
          WorkoutSetRow,
          PrefetchHooks Function()
        > {
  $$WorkoutSetsTableTableManager(_$RepForgeDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> workoutSetId = const Value.absent(),
                Value<String> exerciseSource = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> exerciseDisplayNameSnapshot =
                    const Value.absent(),
                Value<String?> catalogVersionSnapshot = const Value.absent(),
                Value<String?> workoutSessionId = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<double> loadKg = const Value.absent(),
                Value<DateTime> performedAt = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion(
                workoutSetId: workoutSetId,
                exerciseSource: exerciseSource,
                exerciseId: exerciseId,
                exerciseDisplayNameSnapshot: exerciseDisplayNameSnapshot,
                catalogVersionSnapshot: catalogVersionSnapshot,
                workoutSessionId: workoutSessionId,
                repetitions: repetitions,
                loadKg: loadKg,
                performedAt: performedAt,
                comment: comment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String workoutSetId,
                required String exerciseSource,
                required String exerciseId,
                required String exerciseDisplayNameSnapshot,
                Value<String?> catalogVersionSnapshot = const Value.absent(),
                Value<String?> workoutSessionId = const Value.absent(),
                required int repetitions,
                required double loadKg,
                required DateTime performedAt,
                Value<String?> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                workoutSetId: workoutSetId,
                exerciseSource: exerciseSource,
                exerciseId: exerciseId,
                exerciseDisplayNameSnapshot: exerciseDisplayNameSnapshot,
                catalogVersionSnapshot: catalogVersionSnapshot,
                workoutSessionId: workoutSessionId,
                repetitions: repetitions,
                loadKg: loadKg,
                performedAt: performedAt,
                comment: comment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $WorkoutSetsTable,
      WorkoutSetRow,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (
        WorkoutSetRow,
        BaseReferences<_$RepForgeDatabase, $WorkoutSetsTable, WorkoutSetRow>,
      ),
      WorkoutSetRow,
      PrefetchHooks Function()
    >;

class $RepForgeDatabaseManager {
  final _$RepForgeDatabase _db;
  $RepForgeDatabaseManager(this._db);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
}
