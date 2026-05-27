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

class $OfficialExercisesTable extends OfficialExercises
    with TableInfo<$OfficialExercisesTable, OfficialExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfficialExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _catalogIdMeta = const VerificationMeta(
    'catalogId',
  );
  @override
  late final GeneratedColumn<String> catalogId = GeneratedColumn<String>(
    'catalog_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(catalog_id) > 0)',
  );
  static const VerificationMeta _catalogVersionMeta = const VerificationMeta(
    'catalogVersion',
  );
  @override
  late final GeneratedColumn<String> catalogVersion = GeneratedColumn<String>(
    'catalog_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(catalog_version) > 0)',
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (schema_version > 0)',
  );
  static const VerificationMeta _englishNameMeta = const VerificationMeta(
    'englishName',
  );
  @override
  late final GeneratedColumn<String> englishName = GeneratedColumn<String>(
    'english_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(english_name) > 0)',
  );
  static const VerificationMeta _germanNameMeta = const VerificationMeta(
    'germanName',
  );
  @override
  late final GeneratedColumn<String> germanName = GeneratedColumn<String>(
    'german_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(german_name) > 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    catalogId,
    catalogVersion,
    schemaVersion,
    englishName,
    germanName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'official_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfficialExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('catalog_id')) {
      context.handle(
        _catalogIdMeta,
        catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catalogIdMeta);
    }
    if (data.containsKey('catalog_version')) {
      context.handle(
        _catalogVersionMeta,
        catalogVersion.isAcceptableOrUnknown(
          data['catalog_version']!,
          _catalogVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_catalogVersionMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('english_name')) {
      context.handle(
        _englishNameMeta,
        englishName.isAcceptableOrUnknown(
          data['english_name']!,
          _englishNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_englishNameMeta);
    }
    if (data.containsKey('german_name')) {
      context.handle(
        _germanNameMeta,
        germanName.isAcceptableOrUnknown(data['german_name']!, _germanNameMeta),
      );
    } else if (isInserting) {
      context.missing(_germanNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {catalogId};
  @override
  OfficialExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfficialExerciseRow(
      catalogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_id'],
      )!,
      catalogVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_version'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      englishName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}english_name'],
      )!,
      germanName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}german_name'],
      )!,
    );
  }

  @override
  $OfficialExercisesTable createAlias(String alias) {
    return $OfficialExercisesTable(attachedDatabase, alias);
  }
}

class OfficialExerciseRow extends DataClass
    implements Insertable<OfficialExerciseRow> {
  final String catalogId;
  final String catalogVersion;
  final int schemaVersion;
  final String englishName;
  final String germanName;
  const OfficialExerciseRow({
    required this.catalogId,
    required this.catalogVersion,
    required this.schemaVersion,
    required this.englishName,
    required this.germanName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['catalog_id'] = Variable<String>(catalogId);
    map['catalog_version'] = Variable<String>(catalogVersion);
    map['schema_version'] = Variable<int>(schemaVersion);
    map['english_name'] = Variable<String>(englishName);
    map['german_name'] = Variable<String>(germanName);
    return map;
  }

  OfficialExercisesCompanion toCompanion(bool nullToAbsent) {
    return OfficialExercisesCompanion(
      catalogId: Value(catalogId),
      catalogVersion: Value(catalogVersion),
      schemaVersion: Value(schemaVersion),
      englishName: Value(englishName),
      germanName: Value(germanName),
    );
  }

  factory OfficialExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfficialExerciseRow(
      catalogId: serializer.fromJson<String>(json['catalogId']),
      catalogVersion: serializer.fromJson<String>(json['catalogVersion']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      englishName: serializer.fromJson<String>(json['englishName']),
      germanName: serializer.fromJson<String>(json['germanName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'catalogId': serializer.toJson<String>(catalogId),
      'catalogVersion': serializer.toJson<String>(catalogVersion),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'englishName': serializer.toJson<String>(englishName),
      'germanName': serializer.toJson<String>(germanName),
    };
  }

  OfficialExerciseRow copyWith({
    String? catalogId,
    String? catalogVersion,
    int? schemaVersion,
    String? englishName,
    String? germanName,
  }) => OfficialExerciseRow(
    catalogId: catalogId ?? this.catalogId,
    catalogVersion: catalogVersion ?? this.catalogVersion,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    englishName: englishName ?? this.englishName,
    germanName: germanName ?? this.germanName,
  );
  OfficialExerciseRow copyWithCompanion(OfficialExercisesCompanion data) {
    return OfficialExerciseRow(
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      catalogVersion: data.catalogVersion.present
          ? data.catalogVersion.value
          : this.catalogVersion,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      englishName: data.englishName.present
          ? data.englishName.value
          : this.englishName,
      germanName: data.germanName.present
          ? data.germanName.value
          : this.germanName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfficialExerciseRow(')
          ..write('catalogId: $catalogId, ')
          ..write('catalogVersion: $catalogVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('englishName: $englishName, ')
          ..write('germanName: $germanName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    catalogId,
    catalogVersion,
    schemaVersion,
    englishName,
    germanName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfficialExerciseRow &&
          other.catalogId == this.catalogId &&
          other.catalogVersion == this.catalogVersion &&
          other.schemaVersion == this.schemaVersion &&
          other.englishName == this.englishName &&
          other.germanName == this.germanName);
}

class OfficialExercisesCompanion extends UpdateCompanion<OfficialExerciseRow> {
  final Value<String> catalogId;
  final Value<String> catalogVersion;
  final Value<int> schemaVersion;
  final Value<String> englishName;
  final Value<String> germanName;
  final Value<int> rowid;
  const OfficialExercisesCompanion({
    this.catalogId = const Value.absent(),
    this.catalogVersion = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.englishName = const Value.absent(),
    this.germanName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfficialExercisesCompanion.insert({
    required String catalogId,
    required String catalogVersion,
    required int schemaVersion,
    required String englishName,
    required String germanName,
    this.rowid = const Value.absent(),
  }) : catalogId = Value(catalogId),
       catalogVersion = Value(catalogVersion),
       schemaVersion = Value(schemaVersion),
       englishName = Value(englishName),
       germanName = Value(germanName);
  static Insertable<OfficialExerciseRow> custom({
    Expression<String>? catalogId,
    Expression<String>? catalogVersion,
    Expression<int>? schemaVersion,
    Expression<String>? englishName,
    Expression<String>? germanName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (catalogId != null) 'catalog_id': catalogId,
      if (catalogVersion != null) 'catalog_version': catalogVersion,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (englishName != null) 'english_name': englishName,
      if (germanName != null) 'german_name': germanName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfficialExercisesCompanion copyWith({
    Value<String>? catalogId,
    Value<String>? catalogVersion,
    Value<int>? schemaVersion,
    Value<String>? englishName,
    Value<String>? germanName,
    Value<int>? rowid,
  }) {
    return OfficialExercisesCompanion(
      catalogId: catalogId ?? this.catalogId,
      catalogVersion: catalogVersion ?? this.catalogVersion,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      englishName: englishName ?? this.englishName,
      germanName: germanName ?? this.germanName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (catalogId.present) {
      map['catalog_id'] = Variable<String>(catalogId.value);
    }
    if (catalogVersion.present) {
      map['catalog_version'] = Variable<String>(catalogVersion.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (englishName.present) {
      map['english_name'] = Variable<String>(englishName.value);
    }
    if (germanName.present) {
      map['german_name'] = Variable<String>(germanName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfficialExercisesCompanion(')
          ..write('catalogId: $catalogId, ')
          ..write('catalogVersion: $catalogVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('englishName: $englishName, ')
          ..write('germanName: $germanName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfficialExerciseEquipmentTagsTable extends OfficialExerciseEquipmentTags
    with
        TableInfo<
          $OfficialExerciseEquipmentTagsTable,
          OfficialExerciseEquipmentTagRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfficialExerciseEquipmentTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _catalogIdMeta = const VerificationMeta(
    'catalogId',
  );
  @override
  late final GeneratedColumn<String> catalogId = GeneratedColumn<String>(
    'catalog_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(catalog_id) > 0)',
  );
  static const VerificationMeta _equipmentTagMeta = const VerificationMeta(
    'equipmentTag',
  );
  @override
  late final GeneratedColumn<String> equipmentTag = GeneratedColumn<String>(
    'equipment_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(equipment_tag) > 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [catalogId, equipmentTag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'official_exercise_equipment_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfficialExerciseEquipmentTagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('catalog_id')) {
      context.handle(
        _catalogIdMeta,
        catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catalogIdMeta);
    }
    if (data.containsKey('equipment_tag')) {
      context.handle(
        _equipmentTagMeta,
        equipmentTag.isAcceptableOrUnknown(
          data['equipment_tag']!,
          _equipmentTagMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentTagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {catalogId, equipmentTag};
  @override
  OfficialExerciseEquipmentTagRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfficialExerciseEquipmentTagRow(
      catalogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_id'],
      )!,
      equipmentTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_tag'],
      )!,
    );
  }

  @override
  $OfficialExerciseEquipmentTagsTable createAlias(String alias) {
    return $OfficialExerciseEquipmentTagsTable(attachedDatabase, alias);
  }
}

class OfficialExerciseEquipmentTagRow extends DataClass
    implements Insertable<OfficialExerciseEquipmentTagRow> {
  final String catalogId;
  final String equipmentTag;
  const OfficialExerciseEquipmentTagRow({
    required this.catalogId,
    required this.equipmentTag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['catalog_id'] = Variable<String>(catalogId);
    map['equipment_tag'] = Variable<String>(equipmentTag);
    return map;
  }

  OfficialExerciseEquipmentTagsCompanion toCompanion(bool nullToAbsent) {
    return OfficialExerciseEquipmentTagsCompanion(
      catalogId: Value(catalogId),
      equipmentTag: Value(equipmentTag),
    );
  }

  factory OfficialExerciseEquipmentTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfficialExerciseEquipmentTagRow(
      catalogId: serializer.fromJson<String>(json['catalogId']),
      equipmentTag: serializer.fromJson<String>(json['equipmentTag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'catalogId': serializer.toJson<String>(catalogId),
      'equipmentTag': serializer.toJson<String>(equipmentTag),
    };
  }

  OfficialExerciseEquipmentTagRow copyWith({
    String? catalogId,
    String? equipmentTag,
  }) => OfficialExerciseEquipmentTagRow(
    catalogId: catalogId ?? this.catalogId,
    equipmentTag: equipmentTag ?? this.equipmentTag,
  );
  OfficialExerciseEquipmentTagRow copyWithCompanion(
    OfficialExerciseEquipmentTagsCompanion data,
  ) {
    return OfficialExerciseEquipmentTagRow(
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      equipmentTag: data.equipmentTag.present
          ? data.equipmentTag.value
          : this.equipmentTag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfficialExerciseEquipmentTagRow(')
          ..write('catalogId: $catalogId, ')
          ..write('equipmentTag: $equipmentTag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(catalogId, equipmentTag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfficialExerciseEquipmentTagRow &&
          other.catalogId == this.catalogId &&
          other.equipmentTag == this.equipmentTag);
}

class OfficialExerciseEquipmentTagsCompanion
    extends UpdateCompanion<OfficialExerciseEquipmentTagRow> {
  final Value<String> catalogId;
  final Value<String> equipmentTag;
  final Value<int> rowid;
  const OfficialExerciseEquipmentTagsCompanion({
    this.catalogId = const Value.absent(),
    this.equipmentTag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfficialExerciseEquipmentTagsCompanion.insert({
    required String catalogId,
    required String equipmentTag,
    this.rowid = const Value.absent(),
  }) : catalogId = Value(catalogId),
       equipmentTag = Value(equipmentTag);
  static Insertable<OfficialExerciseEquipmentTagRow> custom({
    Expression<String>? catalogId,
    Expression<String>? equipmentTag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (catalogId != null) 'catalog_id': catalogId,
      if (equipmentTag != null) 'equipment_tag': equipmentTag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfficialExerciseEquipmentTagsCompanion copyWith({
    Value<String>? catalogId,
    Value<String>? equipmentTag,
    Value<int>? rowid,
  }) {
    return OfficialExerciseEquipmentTagsCompanion(
      catalogId: catalogId ?? this.catalogId,
      equipmentTag: equipmentTag ?? this.equipmentTag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (catalogId.present) {
      map['catalog_id'] = Variable<String>(catalogId.value);
    }
    if (equipmentTag.present) {
      map['equipment_tag'] = Variable<String>(equipmentTag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfficialExerciseEquipmentTagsCompanion(')
          ..write('catalogId: $catalogId, ')
          ..write('equipmentTag: $equipmentTag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfficialExerciseMovementPatternsTable
    extends OfficialExerciseMovementPatterns
    with
        TableInfo<
          $OfficialExerciseMovementPatternsTable,
          OfficialExerciseMovementPatternRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfficialExerciseMovementPatternsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _catalogIdMeta = const VerificationMeta(
    'catalogId',
  );
  @override
  late final GeneratedColumn<String> catalogId = GeneratedColumn<String>(
    'catalog_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(catalog_id) > 0)',
  );
  static const VerificationMeta _movementPatternMeta = const VerificationMeta(
    'movementPattern',
  );
  @override
  late final GeneratedColumn<String> movementPattern = GeneratedColumn<String>(
    'movement_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(movement_pattern) > 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [catalogId, movementPattern];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'official_exercise_movement_patterns';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfficialExerciseMovementPatternRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('catalog_id')) {
      context.handle(
        _catalogIdMeta,
        catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catalogIdMeta);
    }
    if (data.containsKey('movement_pattern')) {
      context.handle(
        _movementPatternMeta,
        movementPattern.isAcceptableOrUnknown(
          data['movement_pattern']!,
          _movementPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_movementPatternMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {catalogId, movementPattern};
  @override
  OfficialExerciseMovementPatternRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfficialExerciseMovementPatternRow(
      catalogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_id'],
      )!,
      movementPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement_pattern'],
      )!,
    );
  }

  @override
  $OfficialExerciseMovementPatternsTable createAlias(String alias) {
    return $OfficialExerciseMovementPatternsTable(attachedDatabase, alias);
  }
}

class OfficialExerciseMovementPatternRow extends DataClass
    implements Insertable<OfficialExerciseMovementPatternRow> {
  final String catalogId;
  final String movementPattern;
  const OfficialExerciseMovementPatternRow({
    required this.catalogId,
    required this.movementPattern,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['catalog_id'] = Variable<String>(catalogId);
    map['movement_pattern'] = Variable<String>(movementPattern);
    return map;
  }

  OfficialExerciseMovementPatternsCompanion toCompanion(bool nullToAbsent) {
    return OfficialExerciseMovementPatternsCompanion(
      catalogId: Value(catalogId),
      movementPattern: Value(movementPattern),
    );
  }

  factory OfficialExerciseMovementPatternRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfficialExerciseMovementPatternRow(
      catalogId: serializer.fromJson<String>(json['catalogId']),
      movementPattern: serializer.fromJson<String>(json['movementPattern']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'catalogId': serializer.toJson<String>(catalogId),
      'movementPattern': serializer.toJson<String>(movementPattern),
    };
  }

  OfficialExerciseMovementPatternRow copyWith({
    String? catalogId,
    String? movementPattern,
  }) => OfficialExerciseMovementPatternRow(
    catalogId: catalogId ?? this.catalogId,
    movementPattern: movementPattern ?? this.movementPattern,
  );
  OfficialExerciseMovementPatternRow copyWithCompanion(
    OfficialExerciseMovementPatternsCompanion data,
  ) {
    return OfficialExerciseMovementPatternRow(
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      movementPattern: data.movementPattern.present
          ? data.movementPattern.value
          : this.movementPattern,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfficialExerciseMovementPatternRow(')
          ..write('catalogId: $catalogId, ')
          ..write('movementPattern: $movementPattern')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(catalogId, movementPattern);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfficialExerciseMovementPatternRow &&
          other.catalogId == this.catalogId &&
          other.movementPattern == this.movementPattern);
}

class OfficialExerciseMovementPatternsCompanion
    extends UpdateCompanion<OfficialExerciseMovementPatternRow> {
  final Value<String> catalogId;
  final Value<String> movementPattern;
  final Value<int> rowid;
  const OfficialExerciseMovementPatternsCompanion({
    this.catalogId = const Value.absent(),
    this.movementPattern = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfficialExerciseMovementPatternsCompanion.insert({
    required String catalogId,
    required String movementPattern,
    this.rowid = const Value.absent(),
  }) : catalogId = Value(catalogId),
       movementPattern = Value(movementPattern);
  static Insertable<OfficialExerciseMovementPatternRow> custom({
    Expression<String>? catalogId,
    Expression<String>? movementPattern,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (catalogId != null) 'catalog_id': catalogId,
      if (movementPattern != null) 'movement_pattern': movementPattern,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfficialExerciseMovementPatternsCompanion copyWith({
    Value<String>? catalogId,
    Value<String>? movementPattern,
    Value<int>? rowid,
  }) {
    return OfficialExerciseMovementPatternsCompanion(
      catalogId: catalogId ?? this.catalogId,
      movementPattern: movementPattern ?? this.movementPattern,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (catalogId.present) {
      map['catalog_id'] = Variable<String>(catalogId.value);
    }
    if (movementPattern.present) {
      map['movement_pattern'] = Variable<String>(movementPattern.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfficialExerciseMovementPatternsCompanion(')
          ..write('catalogId: $catalogId, ')
          ..write('movementPattern: $movementPattern, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfficialExerciseMuscleGroupsTable extends OfficialExerciseMuscleGroups
    with
        TableInfo<
          $OfficialExerciseMuscleGroupsTable,
          OfficialExerciseMuscleGroupRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfficialExerciseMuscleGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _catalogIdMeta = const VerificationMeta(
    'catalogId',
  );
  @override
  late final GeneratedColumn<String> catalogId = GeneratedColumn<String>(
    'catalog_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(catalog_id) > 0)',
  );
  static const VerificationMeta _muscleGroupMeta = const VerificationMeta(
    'muscleGroup',
  );
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
    'muscle_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(muscle_group) > 0)',
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (role IN (\'primary\', \'secondary\'))',
  );
  @override
  List<GeneratedColumn> get $columns => [catalogId, muscleGroup, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'official_exercise_muscle_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfficialExerciseMuscleGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('catalog_id')) {
      context.handle(
        _catalogIdMeta,
        catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catalogIdMeta);
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
        _muscleGroupMeta,
        muscleGroup.isAcceptableOrUnknown(
          data['muscle_group']!,
          _muscleGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_muscleGroupMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {catalogId, muscleGroup, role};
  @override
  OfficialExerciseMuscleGroupRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfficialExerciseMuscleGroupRow(
      catalogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_id'],
      )!,
      muscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_group'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
    );
  }

  @override
  $OfficialExerciseMuscleGroupsTable createAlias(String alias) {
    return $OfficialExerciseMuscleGroupsTable(attachedDatabase, alias);
  }
}

class OfficialExerciseMuscleGroupRow extends DataClass
    implements Insertable<OfficialExerciseMuscleGroupRow> {
  final String catalogId;
  final String muscleGroup;
  final String role;
  const OfficialExerciseMuscleGroupRow({
    required this.catalogId,
    required this.muscleGroup,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['catalog_id'] = Variable<String>(catalogId);
    map['muscle_group'] = Variable<String>(muscleGroup);
    map['role'] = Variable<String>(role);
    return map;
  }

  OfficialExerciseMuscleGroupsCompanion toCompanion(bool nullToAbsent) {
    return OfficialExerciseMuscleGroupsCompanion(
      catalogId: Value(catalogId),
      muscleGroup: Value(muscleGroup),
      role: Value(role),
    );
  }

  factory OfficialExerciseMuscleGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfficialExerciseMuscleGroupRow(
      catalogId: serializer.fromJson<String>(json['catalogId']),
      muscleGroup: serializer.fromJson<String>(json['muscleGroup']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'catalogId': serializer.toJson<String>(catalogId),
      'muscleGroup': serializer.toJson<String>(muscleGroup),
      'role': serializer.toJson<String>(role),
    };
  }

  OfficialExerciseMuscleGroupRow copyWith({
    String? catalogId,
    String? muscleGroup,
    String? role,
  }) => OfficialExerciseMuscleGroupRow(
    catalogId: catalogId ?? this.catalogId,
    muscleGroup: muscleGroup ?? this.muscleGroup,
    role: role ?? this.role,
  );
  OfficialExerciseMuscleGroupRow copyWithCompanion(
    OfficialExerciseMuscleGroupsCompanion data,
  ) {
    return OfficialExerciseMuscleGroupRow(
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      muscleGroup: data.muscleGroup.present
          ? data.muscleGroup.value
          : this.muscleGroup,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfficialExerciseMuscleGroupRow(')
          ..write('catalogId: $catalogId, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(catalogId, muscleGroup, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfficialExerciseMuscleGroupRow &&
          other.catalogId == this.catalogId &&
          other.muscleGroup == this.muscleGroup &&
          other.role == this.role);
}

class OfficialExerciseMuscleGroupsCompanion
    extends UpdateCompanion<OfficialExerciseMuscleGroupRow> {
  final Value<String> catalogId;
  final Value<String> muscleGroup;
  final Value<String> role;
  final Value<int> rowid;
  const OfficialExerciseMuscleGroupsCompanion({
    this.catalogId = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfficialExerciseMuscleGroupsCompanion.insert({
    required String catalogId,
    required String muscleGroup,
    required String role,
    this.rowid = const Value.absent(),
  }) : catalogId = Value(catalogId),
       muscleGroup = Value(muscleGroup),
       role = Value(role);
  static Insertable<OfficialExerciseMuscleGroupRow> custom({
    Expression<String>? catalogId,
    Expression<String>? muscleGroup,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (catalogId != null) 'catalog_id': catalogId,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfficialExerciseMuscleGroupsCompanion copyWith({
    Value<String>? catalogId,
    Value<String>? muscleGroup,
    Value<String>? role,
    Value<int>? rowid,
  }) {
    return OfficialExerciseMuscleGroupsCompanion(
      catalogId: catalogId ?? this.catalogId,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (catalogId.present) {
      map['catalog_id'] = Variable<String>(catalogId.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfficialExerciseMuscleGroupsCompanion(')
          ..write('catalogId: $catalogId, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogImportsTable extends CatalogImports
    with TableInfo<$CatalogImportsTable, CatalogImportRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogImportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _catalogVersionMeta = const VerificationMeta(
    'catalogVersion',
  );
  @override
  late final GeneratedColumn<String> catalogVersion = GeneratedColumn<String>(
    'catalog_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(catalog_version) > 0)',
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (schema_version > 0)',
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    catalogVersion,
    schemaVersion,
    importedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_imports';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogImportRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('catalog_version')) {
      context.handle(
        _catalogVersionMeta,
        catalogVersion.isAcceptableOrUnknown(
          data['catalog_version']!,
          _catalogVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_catalogVersionMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {catalogVersion};
  @override
  CatalogImportRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogImportRow(
      catalogVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_version'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
    );
  }

  @override
  $CatalogImportsTable createAlias(String alias) {
    return $CatalogImportsTable(attachedDatabase, alias);
  }
}

class CatalogImportRow extends DataClass
    implements Insertable<CatalogImportRow> {
  final String catalogVersion;
  final int schemaVersion;
  final DateTime importedAt;
  const CatalogImportRow({
    required this.catalogVersion,
    required this.schemaVersion,
    required this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['catalog_version'] = Variable<String>(catalogVersion);
    map['schema_version'] = Variable<int>(schemaVersion);
    map['imported_at'] = Variable<DateTime>(importedAt);
    return map;
  }

  CatalogImportsCompanion toCompanion(bool nullToAbsent) {
    return CatalogImportsCompanion(
      catalogVersion: Value(catalogVersion),
      schemaVersion: Value(schemaVersion),
      importedAt: Value(importedAt),
    );
  }

  factory CatalogImportRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogImportRow(
      catalogVersion: serializer.fromJson<String>(json['catalogVersion']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'catalogVersion': serializer.toJson<String>(catalogVersion),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'importedAt': serializer.toJson<DateTime>(importedAt),
    };
  }

  CatalogImportRow copyWith({
    String? catalogVersion,
    int? schemaVersion,
    DateTime? importedAt,
  }) => CatalogImportRow(
    catalogVersion: catalogVersion ?? this.catalogVersion,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    importedAt: importedAt ?? this.importedAt,
  );
  CatalogImportRow copyWithCompanion(CatalogImportsCompanion data) {
    return CatalogImportRow(
      catalogVersion: data.catalogVersion.present
          ? data.catalogVersion.value
          : this.catalogVersion,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogImportRow(')
          ..write('catalogVersion: $catalogVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(catalogVersion, schemaVersion, importedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogImportRow &&
          other.catalogVersion == this.catalogVersion &&
          other.schemaVersion == this.schemaVersion &&
          other.importedAt == this.importedAt);
}

class CatalogImportsCompanion extends UpdateCompanion<CatalogImportRow> {
  final Value<String> catalogVersion;
  final Value<int> schemaVersion;
  final Value<DateTime> importedAt;
  final Value<int> rowid;
  const CatalogImportsCompanion({
    this.catalogVersion = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogImportsCompanion.insert({
    required String catalogVersion,
    required int schemaVersion,
    required DateTime importedAt,
    this.rowid = const Value.absent(),
  }) : catalogVersion = Value(catalogVersion),
       schemaVersion = Value(schemaVersion),
       importedAt = Value(importedAt);
  static Insertable<CatalogImportRow> custom({
    Expression<String>? catalogVersion,
    Expression<int>? schemaVersion,
    Expression<DateTime>? importedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (catalogVersion != null) 'catalog_version': catalogVersion,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (importedAt != null) 'imported_at': importedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogImportsCompanion copyWith({
    Value<String>? catalogVersion,
    Value<int>? schemaVersion,
    Value<DateTime>? importedAt,
    Value<int>? rowid,
  }) {
    return CatalogImportsCompanion(
      catalogVersion: catalogVersion ?? this.catalogVersion,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      importedAt: importedAt ?? this.importedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (catalogVersion.present) {
      map['catalog_version'] = Variable<String>(catalogVersion.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogImportsCompanion(')
          ..write('catalogVersion: $catalogVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('importedAt: $importedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$RepForgeDatabase extends GeneratedDatabase {
  _$RepForgeDatabase(QueryExecutor e) : super(e);
  $RepForgeDatabaseManager get managers => $RepForgeDatabaseManager(this);
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $OfficialExercisesTable officialExercises =
      $OfficialExercisesTable(this);
  late final $OfficialExerciseEquipmentTagsTable officialExerciseEquipmentTags =
      $OfficialExerciseEquipmentTagsTable(this);
  late final $OfficialExerciseMovementPatternsTable
  officialExerciseMovementPatterns = $OfficialExerciseMovementPatternsTable(
    this,
  );
  late final $OfficialExerciseMuscleGroupsTable officialExerciseMuscleGroups =
      $OfficialExerciseMuscleGroupsTable(this);
  late final $CatalogImportsTable catalogImports = $CatalogImportsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutSets,
    officialExercises,
    officialExerciseEquipmentTags,
    officialExerciseMovementPatterns,
    officialExerciseMuscleGroups,
    catalogImports,
  ];
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
typedef $$OfficialExercisesTableCreateCompanionBuilder =
    OfficialExercisesCompanion Function({
      required String catalogId,
      required String catalogVersion,
      required int schemaVersion,
      required String englishName,
      required String germanName,
      Value<int> rowid,
    });
typedef $$OfficialExercisesTableUpdateCompanionBuilder =
    OfficialExercisesCompanion Function({
      Value<String> catalogId,
      Value<String> catalogVersion,
      Value<int> schemaVersion,
      Value<String> englishName,
      Value<String> germanName,
      Value<int> rowid,
    });

class $$OfficialExercisesTableFilterComposer
    extends Composer<_$RepForgeDatabase, $OfficialExercisesTable> {
  $$OfficialExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get englishName => $composableBuilder(
    column: $table.englishName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get germanName => $composableBuilder(
    column: $table.germanName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfficialExercisesTableOrderingComposer
    extends Composer<_$RepForgeDatabase, $OfficialExercisesTable> {
  $$OfficialExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get englishName => $composableBuilder(
    column: $table.englishName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get germanName => $composableBuilder(
    column: $table.germanName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfficialExercisesTableAnnotationComposer
    extends Composer<_$RepForgeDatabase, $OfficialExercisesTable> {
  $$OfficialExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<String> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get englishName => $composableBuilder(
    column: $table.englishName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get germanName => $composableBuilder(
    column: $table.germanName,
    builder: (column) => column,
  );
}

class $$OfficialExercisesTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $OfficialExercisesTable,
          OfficialExerciseRow,
          $$OfficialExercisesTableFilterComposer,
          $$OfficialExercisesTableOrderingComposer,
          $$OfficialExercisesTableAnnotationComposer,
          $$OfficialExercisesTableCreateCompanionBuilder,
          $$OfficialExercisesTableUpdateCompanionBuilder,
          (
            OfficialExerciseRow,
            BaseReferences<
              _$RepForgeDatabase,
              $OfficialExercisesTable,
              OfficialExerciseRow
            >,
          ),
          OfficialExerciseRow,
          PrefetchHooks Function()
        > {
  $$OfficialExercisesTableTableManager(
    _$RepForgeDatabase db,
    $OfficialExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfficialExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfficialExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfficialExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> catalogId = const Value.absent(),
                Value<String> catalogVersion = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<String> englishName = const Value.absent(),
                Value<String> germanName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfficialExercisesCompanion(
                catalogId: catalogId,
                catalogVersion: catalogVersion,
                schemaVersion: schemaVersion,
                englishName: englishName,
                germanName: germanName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String catalogId,
                required String catalogVersion,
                required int schemaVersion,
                required String englishName,
                required String germanName,
                Value<int> rowid = const Value.absent(),
              }) => OfficialExercisesCompanion.insert(
                catalogId: catalogId,
                catalogVersion: catalogVersion,
                schemaVersion: schemaVersion,
                englishName: englishName,
                germanName: germanName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfficialExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $OfficialExercisesTable,
      OfficialExerciseRow,
      $$OfficialExercisesTableFilterComposer,
      $$OfficialExercisesTableOrderingComposer,
      $$OfficialExercisesTableAnnotationComposer,
      $$OfficialExercisesTableCreateCompanionBuilder,
      $$OfficialExercisesTableUpdateCompanionBuilder,
      (
        OfficialExerciseRow,
        BaseReferences<
          _$RepForgeDatabase,
          $OfficialExercisesTable,
          OfficialExerciseRow
        >,
      ),
      OfficialExerciseRow,
      PrefetchHooks Function()
    >;
typedef $$OfficialExerciseEquipmentTagsTableCreateCompanionBuilder =
    OfficialExerciseEquipmentTagsCompanion Function({
      required String catalogId,
      required String equipmentTag,
      Value<int> rowid,
    });
typedef $$OfficialExerciseEquipmentTagsTableUpdateCompanionBuilder =
    OfficialExerciseEquipmentTagsCompanion Function({
      Value<String> catalogId,
      Value<String> equipmentTag,
      Value<int> rowid,
    });

class $$OfficialExerciseEquipmentTagsTableFilterComposer
    extends Composer<_$RepForgeDatabase, $OfficialExerciseEquipmentTagsTable> {
  $$OfficialExerciseEquipmentTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentTag => $composableBuilder(
    column: $table.equipmentTag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfficialExerciseEquipmentTagsTableOrderingComposer
    extends Composer<_$RepForgeDatabase, $OfficialExerciseEquipmentTagsTable> {
  $$OfficialExerciseEquipmentTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentTag => $composableBuilder(
    column: $table.equipmentTag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfficialExerciseEquipmentTagsTableAnnotationComposer
    extends Composer<_$RepForgeDatabase, $OfficialExerciseEquipmentTagsTable> {
  $$OfficialExerciseEquipmentTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<String> get equipmentTag => $composableBuilder(
    column: $table.equipmentTag,
    builder: (column) => column,
  );
}

class $$OfficialExerciseEquipmentTagsTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $OfficialExerciseEquipmentTagsTable,
          OfficialExerciseEquipmentTagRow,
          $$OfficialExerciseEquipmentTagsTableFilterComposer,
          $$OfficialExerciseEquipmentTagsTableOrderingComposer,
          $$OfficialExerciseEquipmentTagsTableAnnotationComposer,
          $$OfficialExerciseEquipmentTagsTableCreateCompanionBuilder,
          $$OfficialExerciseEquipmentTagsTableUpdateCompanionBuilder,
          (
            OfficialExerciseEquipmentTagRow,
            BaseReferences<
              _$RepForgeDatabase,
              $OfficialExerciseEquipmentTagsTable,
              OfficialExerciseEquipmentTagRow
            >,
          ),
          OfficialExerciseEquipmentTagRow,
          PrefetchHooks Function()
        > {
  $$OfficialExerciseEquipmentTagsTableTableManager(
    _$RepForgeDatabase db,
    $OfficialExerciseEquipmentTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfficialExerciseEquipmentTagsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$OfficialExerciseEquipmentTagsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OfficialExerciseEquipmentTagsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> catalogId = const Value.absent(),
                Value<String> equipmentTag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfficialExerciseEquipmentTagsCompanion(
                catalogId: catalogId,
                equipmentTag: equipmentTag,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String catalogId,
                required String equipmentTag,
                Value<int> rowid = const Value.absent(),
              }) => OfficialExerciseEquipmentTagsCompanion.insert(
                catalogId: catalogId,
                equipmentTag: equipmentTag,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfficialExerciseEquipmentTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $OfficialExerciseEquipmentTagsTable,
      OfficialExerciseEquipmentTagRow,
      $$OfficialExerciseEquipmentTagsTableFilterComposer,
      $$OfficialExerciseEquipmentTagsTableOrderingComposer,
      $$OfficialExerciseEquipmentTagsTableAnnotationComposer,
      $$OfficialExerciseEquipmentTagsTableCreateCompanionBuilder,
      $$OfficialExerciseEquipmentTagsTableUpdateCompanionBuilder,
      (
        OfficialExerciseEquipmentTagRow,
        BaseReferences<
          _$RepForgeDatabase,
          $OfficialExerciseEquipmentTagsTable,
          OfficialExerciseEquipmentTagRow
        >,
      ),
      OfficialExerciseEquipmentTagRow,
      PrefetchHooks Function()
    >;
typedef $$OfficialExerciseMovementPatternsTableCreateCompanionBuilder =
    OfficialExerciseMovementPatternsCompanion Function({
      required String catalogId,
      required String movementPattern,
      Value<int> rowid,
    });
typedef $$OfficialExerciseMovementPatternsTableUpdateCompanionBuilder =
    OfficialExerciseMovementPatternsCompanion Function({
      Value<String> catalogId,
      Value<String> movementPattern,
      Value<int> rowid,
    });

class $$OfficialExerciseMovementPatternsTableFilterComposer
    extends
        Composer<_$RepForgeDatabase, $OfficialExerciseMovementPatternsTable> {
  $$OfficialExerciseMovementPatternsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movementPattern => $composableBuilder(
    column: $table.movementPattern,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfficialExerciseMovementPatternsTableOrderingComposer
    extends
        Composer<_$RepForgeDatabase, $OfficialExerciseMovementPatternsTable> {
  $$OfficialExerciseMovementPatternsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movementPattern => $composableBuilder(
    column: $table.movementPattern,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfficialExerciseMovementPatternsTableAnnotationComposer
    extends
        Composer<_$RepForgeDatabase, $OfficialExerciseMovementPatternsTable> {
  $$OfficialExerciseMovementPatternsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<String> get movementPattern => $composableBuilder(
    column: $table.movementPattern,
    builder: (column) => column,
  );
}

class $$OfficialExerciseMovementPatternsTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $OfficialExerciseMovementPatternsTable,
          OfficialExerciseMovementPatternRow,
          $$OfficialExerciseMovementPatternsTableFilterComposer,
          $$OfficialExerciseMovementPatternsTableOrderingComposer,
          $$OfficialExerciseMovementPatternsTableAnnotationComposer,
          $$OfficialExerciseMovementPatternsTableCreateCompanionBuilder,
          $$OfficialExerciseMovementPatternsTableUpdateCompanionBuilder,
          (
            OfficialExerciseMovementPatternRow,
            BaseReferences<
              _$RepForgeDatabase,
              $OfficialExerciseMovementPatternsTable,
              OfficialExerciseMovementPatternRow
            >,
          ),
          OfficialExerciseMovementPatternRow,
          PrefetchHooks Function()
        > {
  $$OfficialExerciseMovementPatternsTableTableManager(
    _$RepForgeDatabase db,
    $OfficialExerciseMovementPatternsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfficialExerciseMovementPatternsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$OfficialExerciseMovementPatternsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OfficialExerciseMovementPatternsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> catalogId = const Value.absent(),
                Value<String> movementPattern = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfficialExerciseMovementPatternsCompanion(
                catalogId: catalogId,
                movementPattern: movementPattern,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String catalogId,
                required String movementPattern,
                Value<int> rowid = const Value.absent(),
              }) => OfficialExerciseMovementPatternsCompanion.insert(
                catalogId: catalogId,
                movementPattern: movementPattern,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfficialExerciseMovementPatternsTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $OfficialExerciseMovementPatternsTable,
      OfficialExerciseMovementPatternRow,
      $$OfficialExerciseMovementPatternsTableFilterComposer,
      $$OfficialExerciseMovementPatternsTableOrderingComposer,
      $$OfficialExerciseMovementPatternsTableAnnotationComposer,
      $$OfficialExerciseMovementPatternsTableCreateCompanionBuilder,
      $$OfficialExerciseMovementPatternsTableUpdateCompanionBuilder,
      (
        OfficialExerciseMovementPatternRow,
        BaseReferences<
          _$RepForgeDatabase,
          $OfficialExerciseMovementPatternsTable,
          OfficialExerciseMovementPatternRow
        >,
      ),
      OfficialExerciseMovementPatternRow,
      PrefetchHooks Function()
    >;
typedef $$OfficialExerciseMuscleGroupsTableCreateCompanionBuilder =
    OfficialExerciseMuscleGroupsCompanion Function({
      required String catalogId,
      required String muscleGroup,
      required String role,
      Value<int> rowid,
    });
typedef $$OfficialExerciseMuscleGroupsTableUpdateCompanionBuilder =
    OfficialExerciseMuscleGroupsCompanion Function({
      Value<String> catalogId,
      Value<String> muscleGroup,
      Value<String> role,
      Value<int> rowid,
    });

class $$OfficialExerciseMuscleGroupsTableFilterComposer
    extends Composer<_$RepForgeDatabase, $OfficialExerciseMuscleGroupsTable> {
  $$OfficialExerciseMuscleGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfficialExerciseMuscleGroupsTableOrderingComposer
    extends Composer<_$RepForgeDatabase, $OfficialExerciseMuscleGroupsTable> {
  $$OfficialExerciseMuscleGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfficialExerciseMuscleGroupsTableAnnotationComposer
    extends Composer<_$RepForgeDatabase, $OfficialExerciseMuscleGroupsTable> {
  $$OfficialExerciseMuscleGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$OfficialExerciseMuscleGroupsTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $OfficialExerciseMuscleGroupsTable,
          OfficialExerciseMuscleGroupRow,
          $$OfficialExerciseMuscleGroupsTableFilterComposer,
          $$OfficialExerciseMuscleGroupsTableOrderingComposer,
          $$OfficialExerciseMuscleGroupsTableAnnotationComposer,
          $$OfficialExerciseMuscleGroupsTableCreateCompanionBuilder,
          $$OfficialExerciseMuscleGroupsTableUpdateCompanionBuilder,
          (
            OfficialExerciseMuscleGroupRow,
            BaseReferences<
              _$RepForgeDatabase,
              $OfficialExerciseMuscleGroupsTable,
              OfficialExerciseMuscleGroupRow
            >,
          ),
          OfficialExerciseMuscleGroupRow,
          PrefetchHooks Function()
        > {
  $$OfficialExerciseMuscleGroupsTableTableManager(
    _$RepForgeDatabase db,
    $OfficialExerciseMuscleGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfficialExerciseMuscleGroupsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$OfficialExerciseMuscleGroupsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OfficialExerciseMuscleGroupsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> catalogId = const Value.absent(),
                Value<String> muscleGroup = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfficialExerciseMuscleGroupsCompanion(
                catalogId: catalogId,
                muscleGroup: muscleGroup,
                role: role,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String catalogId,
                required String muscleGroup,
                required String role,
                Value<int> rowid = const Value.absent(),
              }) => OfficialExerciseMuscleGroupsCompanion.insert(
                catalogId: catalogId,
                muscleGroup: muscleGroup,
                role: role,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfficialExerciseMuscleGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $OfficialExerciseMuscleGroupsTable,
      OfficialExerciseMuscleGroupRow,
      $$OfficialExerciseMuscleGroupsTableFilterComposer,
      $$OfficialExerciseMuscleGroupsTableOrderingComposer,
      $$OfficialExerciseMuscleGroupsTableAnnotationComposer,
      $$OfficialExerciseMuscleGroupsTableCreateCompanionBuilder,
      $$OfficialExerciseMuscleGroupsTableUpdateCompanionBuilder,
      (
        OfficialExerciseMuscleGroupRow,
        BaseReferences<
          _$RepForgeDatabase,
          $OfficialExerciseMuscleGroupsTable,
          OfficialExerciseMuscleGroupRow
        >,
      ),
      OfficialExerciseMuscleGroupRow,
      PrefetchHooks Function()
    >;
typedef $$CatalogImportsTableCreateCompanionBuilder =
    CatalogImportsCompanion Function({
      required String catalogVersion,
      required int schemaVersion,
      required DateTime importedAt,
      Value<int> rowid,
    });
typedef $$CatalogImportsTableUpdateCompanionBuilder =
    CatalogImportsCompanion Function({
      Value<String> catalogVersion,
      Value<int> schemaVersion,
      Value<DateTime> importedAt,
      Value<int> rowid,
    });

class $$CatalogImportsTableFilterComposer
    extends Composer<_$RepForgeDatabase, $CatalogImportsTable> {
  $$CatalogImportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogImportsTableOrderingComposer
    extends Composer<_$RepForgeDatabase, $CatalogImportsTable> {
  $$CatalogImportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogImportsTableAnnotationComposer
    extends Composer<_$RepForgeDatabase, $CatalogImportsTable> {
  $$CatalogImportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );
}

class $$CatalogImportsTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $CatalogImportsTable,
          CatalogImportRow,
          $$CatalogImportsTableFilterComposer,
          $$CatalogImportsTableOrderingComposer,
          $$CatalogImportsTableAnnotationComposer,
          $$CatalogImportsTableCreateCompanionBuilder,
          $$CatalogImportsTableUpdateCompanionBuilder,
          (
            CatalogImportRow,
            BaseReferences<
              _$RepForgeDatabase,
              $CatalogImportsTable,
              CatalogImportRow
            >,
          ),
          CatalogImportRow,
          PrefetchHooks Function()
        > {
  $$CatalogImportsTableTableManager(
    _$RepForgeDatabase db,
    $CatalogImportsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogImportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogImportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogImportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> catalogVersion = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogImportsCompanion(
                catalogVersion: catalogVersion,
                schemaVersion: schemaVersion,
                importedAt: importedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String catalogVersion,
                required int schemaVersion,
                required DateTime importedAt,
                Value<int> rowid = const Value.absent(),
              }) => CatalogImportsCompanion.insert(
                catalogVersion: catalogVersion,
                schemaVersion: schemaVersion,
                importedAt: importedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogImportsTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $CatalogImportsTable,
      CatalogImportRow,
      $$CatalogImportsTableFilterComposer,
      $$CatalogImportsTableOrderingComposer,
      $$CatalogImportsTableAnnotationComposer,
      $$CatalogImportsTableCreateCompanionBuilder,
      $$CatalogImportsTableUpdateCompanionBuilder,
      (
        CatalogImportRow,
        BaseReferences<
          _$RepForgeDatabase,
          $CatalogImportsTable,
          CatalogImportRow
        >,
      ),
      CatalogImportRow,
      PrefetchHooks Function()
    >;

class $RepForgeDatabaseManager {
  final _$RepForgeDatabase _db;
  $RepForgeDatabaseManager(this._db);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$OfficialExercisesTableTableManager get officialExercises =>
      $$OfficialExercisesTableTableManager(_db, _db.officialExercises);
  $$OfficialExerciseEquipmentTagsTableTableManager
  get officialExerciseEquipmentTags =>
      $$OfficialExerciseEquipmentTagsTableTableManager(
        _db,
        _db.officialExerciseEquipmentTags,
      );
  $$OfficialExerciseMovementPatternsTableTableManager
  get officialExerciseMovementPatterns =>
      $$OfficialExerciseMovementPatternsTableTableManager(
        _db,
        _db.officialExerciseMovementPatterns,
      );
  $$OfficialExerciseMuscleGroupsTableTableManager
  get officialExerciseMuscleGroups =>
      $$OfficialExerciseMuscleGroupsTableTableManager(
        _db,
        _db.officialExerciseMuscleGroups,
      );
  $$CatalogImportsTableTableManager get catalogImports =>
      $$CatalogImportsTableTableManager(_db, _db.catalogImports);
}
