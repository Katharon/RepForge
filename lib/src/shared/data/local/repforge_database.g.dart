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
  static const VerificationMeta _setLabelMeta = const VerificationMeta(
    'setLabel',
  );
  @override
  late final GeneratedColumn<String> setLabel = GeneratedColumn<String>(
    'set_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NULL CHECK (set_label IS NULL OR set_label = \'\' OR set_label IN (\'none\', \'warmup\', \'failure\', \'personalRecord\', \'dropSet\', \'pain\'))',
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
    setLabel,
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
    if (data.containsKey('set_label')) {
      context.handle(
        _setLabelMeta,
        setLabel.isAcceptableOrUnknown(data['set_label']!, _setLabelMeta),
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
      setLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_label'],
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
  final String? setLabel;
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
    this.setLabel,
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
    if (!nullToAbsent || setLabel != null) {
      map['set_label'] = Variable<String>(setLabel);
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
      setLabel: setLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(setLabel),
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
      setLabel: serializer.fromJson<String?>(json['setLabel']),
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
      'setLabel': serializer.toJson<String?>(setLabel),
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
    Value<String?> setLabel = const Value.absent(),
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
    setLabel: setLabel.present ? setLabel.value : this.setLabel,
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
      setLabel: data.setLabel.present ? data.setLabel.value : this.setLabel,
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
          ..write('comment: $comment, ')
          ..write('setLabel: $setLabel')
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
    setLabel,
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
          other.comment == this.comment &&
          other.setLabel == this.setLabel);
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
  final Value<String?> setLabel;
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
    this.setLabel = const Value.absent(),
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
    this.setLabel = const Value.absent(),
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
    Expression<String>? setLabel,
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
      if (setLabel != null) 'set_label': setLabel,
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
    Value<String?>? setLabel,
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
      setLabel: setLabel ?? this.setLabel,
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
    if (setLabel.present) {
      map['set_label'] = Variable<String>(setLabel.value);
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
          ..write('setLabel: $setLabel, ')
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

class $WorkoutGroupsTable extends WorkoutGroups
    with TableInfo<$WorkoutGroupsTable, WorkoutGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workoutGroupIdMeta = const VerificationMeta(
    'workoutGroupId',
  );
  @override
  late final GeneratedColumn<String> workoutGroupId = GeneratedColumn<String>(
    'workout_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(workout_group_id) > 0)',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(name) > 0)',
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (sort_order >= 0)',
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    workoutGroupId,
    name,
    sortOrder,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('workout_group_id')) {
      context.handle(
        _workoutGroupIdMeta,
        workoutGroupId.isAcceptableOrUnknown(
          data['workout_group_id']!,
          _workoutGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutGroupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workoutGroupId};
  @override
  WorkoutGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutGroupRow(
      workoutGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_group_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $WorkoutGroupsTable createAlias(String alias) {
    return $WorkoutGroupsTable(attachedDatabase, alias);
  }
}

class WorkoutGroupRow extends DataClass implements Insertable<WorkoutGroupRow> {
  final String workoutGroupId;
  final String name;
  final int sortOrder;
  final DateTime? archivedAt;
  const WorkoutGroupRow({
    required this.workoutGroupId,
    required this.name,
    required this.sortOrder,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workout_group_id'] = Variable<String>(workoutGroupId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  WorkoutGroupsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutGroupsCompanion(
      workoutGroupId: Value(workoutGroupId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory WorkoutGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutGroupRow(
      workoutGroupId: serializer.fromJson<String>(json['workoutGroupId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workoutGroupId': serializer.toJson<String>(workoutGroupId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  WorkoutGroupRow copyWith({
    String? workoutGroupId,
    String? name,
    int? sortOrder,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => WorkoutGroupRow(
    workoutGroupId: workoutGroupId ?? this.workoutGroupId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  WorkoutGroupRow copyWithCompanion(WorkoutGroupsCompanion data) {
    return WorkoutGroupRow(
      workoutGroupId: data.workoutGroupId.present
          ? data.workoutGroupId.value
          : this.workoutGroupId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutGroupRow(')
          ..write('workoutGroupId: $workoutGroupId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workoutGroupId, name, sortOrder, archivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutGroupRow &&
          other.workoutGroupId == this.workoutGroupId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.archivedAt == this.archivedAt);
}

class WorkoutGroupsCompanion extends UpdateCompanion<WorkoutGroupRow> {
  final Value<String> workoutGroupId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const WorkoutGroupsCompanion({
    this.workoutGroupId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutGroupsCompanion.insert({
    required String workoutGroupId,
    required String name,
    required int sortOrder,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : workoutGroupId = Value(workoutGroupId),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<WorkoutGroupRow> custom({
    Expression<String>? workoutGroupId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workoutGroupId != null) 'workout_group_id': workoutGroupId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutGroupsCompanion copyWith({
    Value<String>? workoutGroupId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return WorkoutGroupsCompanion(
      workoutGroupId: workoutGroupId ?? this.workoutGroupId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workoutGroupId.present) {
      map['workout_group_id'] = Variable<String>(workoutGroupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutGroupsCompanion(')
          ..write('workoutGroupId: $workoutGroupId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutGroupExerciseAssignmentsTable
    extends WorkoutGroupExerciseAssignments
    with
        TableInfo<
          $WorkoutGroupExerciseAssignmentsTable,
          WorkoutGroupExerciseAssignmentRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutGroupExerciseAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assignmentIdMeta = const VerificationMeta(
    'assignmentId',
  );
  @override
  late final GeneratedColumn<String> assignmentId = GeneratedColumn<String>(
    'assignment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(assignment_id) > 0)',
  );
  static const VerificationMeta _workoutGroupIdMeta = const VerificationMeta(
    'workoutGroupId',
  );
  @override
  late final GeneratedColumn<String> workoutGroupId = GeneratedColumn<String>(
    'workout_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(workout_group_id) > 0)',
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
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (position >= 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    assignmentId,
    workoutGroupId,
    exerciseSource,
    exerciseId,
    exerciseDisplayNameSnapshot,
    catalogVersionSnapshot,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_group_exercise_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutGroupExerciseAssignmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('assignment_id')) {
      context.handle(
        _assignmentIdMeta,
        assignmentId.isAcceptableOrUnknown(
          data['assignment_id']!,
          _assignmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignmentIdMeta);
    }
    if (data.containsKey('workout_group_id')) {
      context.handle(
        _workoutGroupIdMeta,
        workoutGroupId.isAcceptableOrUnknown(
          data['workout_group_id']!,
          _workoutGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutGroupIdMeta);
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
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assignmentId};
  @override
  WorkoutGroupExerciseAssignmentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutGroupExerciseAssignmentRow(
      assignmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assignment_id'],
      )!,
      workoutGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_group_id'],
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
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $WorkoutGroupExerciseAssignmentsTable createAlias(String alias) {
    return $WorkoutGroupExerciseAssignmentsTable(attachedDatabase, alias);
  }
}

class WorkoutGroupExerciseAssignmentRow extends DataClass
    implements Insertable<WorkoutGroupExerciseAssignmentRow> {
  final String assignmentId;
  final String workoutGroupId;
  final String exerciseSource;
  final String exerciseId;
  final String exerciseDisplayNameSnapshot;
  final String? catalogVersionSnapshot;
  final int position;
  const WorkoutGroupExerciseAssignmentRow({
    required this.assignmentId,
    required this.workoutGroupId,
    required this.exerciseSource,
    required this.exerciseId,
    required this.exerciseDisplayNameSnapshot,
    this.catalogVersionSnapshot,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['assignment_id'] = Variable<String>(assignmentId);
    map['workout_group_id'] = Variable<String>(workoutGroupId);
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
    map['position'] = Variable<int>(position);
    return map;
  }

  WorkoutGroupExerciseAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutGroupExerciseAssignmentsCompanion(
      assignmentId: Value(assignmentId),
      workoutGroupId: Value(workoutGroupId),
      exerciseSource: Value(exerciseSource),
      exerciseId: Value(exerciseId),
      exerciseDisplayNameSnapshot: Value(exerciseDisplayNameSnapshot),
      catalogVersionSnapshot: catalogVersionSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogVersionSnapshot),
      position: Value(position),
    );
  }

  factory WorkoutGroupExerciseAssignmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutGroupExerciseAssignmentRow(
      assignmentId: serializer.fromJson<String>(json['assignmentId']),
      workoutGroupId: serializer.fromJson<String>(json['workoutGroupId']),
      exerciseSource: serializer.fromJson<String>(json['exerciseSource']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      exerciseDisplayNameSnapshot: serializer.fromJson<String>(
        json['exerciseDisplayNameSnapshot'],
      ),
      catalogVersionSnapshot: serializer.fromJson<String?>(
        json['catalogVersionSnapshot'],
      ),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assignmentId': serializer.toJson<String>(assignmentId),
      'workoutGroupId': serializer.toJson<String>(workoutGroupId),
      'exerciseSource': serializer.toJson<String>(exerciseSource),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'exerciseDisplayNameSnapshot': serializer.toJson<String>(
        exerciseDisplayNameSnapshot,
      ),
      'catalogVersionSnapshot': serializer.toJson<String?>(
        catalogVersionSnapshot,
      ),
      'position': serializer.toJson<int>(position),
    };
  }

  WorkoutGroupExerciseAssignmentRow copyWith({
    String? assignmentId,
    String? workoutGroupId,
    String? exerciseSource,
    String? exerciseId,
    String? exerciseDisplayNameSnapshot,
    Value<String?> catalogVersionSnapshot = const Value.absent(),
    int? position,
  }) => WorkoutGroupExerciseAssignmentRow(
    assignmentId: assignmentId ?? this.assignmentId,
    workoutGroupId: workoutGroupId ?? this.workoutGroupId,
    exerciseSource: exerciseSource ?? this.exerciseSource,
    exerciseId: exerciseId ?? this.exerciseId,
    exerciseDisplayNameSnapshot:
        exerciseDisplayNameSnapshot ?? this.exerciseDisplayNameSnapshot,
    catalogVersionSnapshot: catalogVersionSnapshot.present
        ? catalogVersionSnapshot.value
        : this.catalogVersionSnapshot,
    position: position ?? this.position,
  );
  WorkoutGroupExerciseAssignmentRow copyWithCompanion(
    WorkoutGroupExerciseAssignmentsCompanion data,
  ) {
    return WorkoutGroupExerciseAssignmentRow(
      assignmentId: data.assignmentId.present
          ? data.assignmentId.value
          : this.assignmentId,
      workoutGroupId: data.workoutGroupId.present
          ? data.workoutGroupId.value
          : this.workoutGroupId,
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
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutGroupExerciseAssignmentRow(')
          ..write('assignmentId: $assignmentId, ')
          ..write('workoutGroupId: $workoutGroupId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseDisplayNameSnapshot: $exerciseDisplayNameSnapshot, ')
          ..write('catalogVersionSnapshot: $catalogVersionSnapshot, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    assignmentId,
    workoutGroupId,
    exerciseSource,
    exerciseId,
    exerciseDisplayNameSnapshot,
    catalogVersionSnapshot,
    position,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutGroupExerciseAssignmentRow &&
          other.assignmentId == this.assignmentId &&
          other.workoutGroupId == this.workoutGroupId &&
          other.exerciseSource == this.exerciseSource &&
          other.exerciseId == this.exerciseId &&
          other.exerciseDisplayNameSnapshot ==
              this.exerciseDisplayNameSnapshot &&
          other.catalogVersionSnapshot == this.catalogVersionSnapshot &&
          other.position == this.position);
}

class WorkoutGroupExerciseAssignmentsCompanion
    extends UpdateCompanion<WorkoutGroupExerciseAssignmentRow> {
  final Value<String> assignmentId;
  final Value<String> workoutGroupId;
  final Value<String> exerciseSource;
  final Value<String> exerciseId;
  final Value<String> exerciseDisplayNameSnapshot;
  final Value<String?> catalogVersionSnapshot;
  final Value<int> position;
  final Value<int> rowid;
  const WorkoutGroupExerciseAssignmentsCompanion({
    this.assignmentId = const Value.absent(),
    this.workoutGroupId = const Value.absent(),
    this.exerciseSource = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.exerciseDisplayNameSnapshot = const Value.absent(),
    this.catalogVersionSnapshot = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutGroupExerciseAssignmentsCompanion.insert({
    required String assignmentId,
    required String workoutGroupId,
    required String exerciseSource,
    required String exerciseId,
    required String exerciseDisplayNameSnapshot,
    this.catalogVersionSnapshot = const Value.absent(),
    required int position,
    this.rowid = const Value.absent(),
  }) : assignmentId = Value(assignmentId),
       workoutGroupId = Value(workoutGroupId),
       exerciseSource = Value(exerciseSource),
       exerciseId = Value(exerciseId),
       exerciseDisplayNameSnapshot = Value(exerciseDisplayNameSnapshot),
       position = Value(position);
  static Insertable<WorkoutGroupExerciseAssignmentRow> custom({
    Expression<String>? assignmentId,
    Expression<String>? workoutGroupId,
    Expression<String>? exerciseSource,
    Expression<String>? exerciseId,
    Expression<String>? exerciseDisplayNameSnapshot,
    Expression<String>? catalogVersionSnapshot,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assignmentId != null) 'assignment_id': assignmentId,
      if (workoutGroupId != null) 'workout_group_id': workoutGroupId,
      if (exerciseSource != null) 'exercise_source': exerciseSource,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (exerciseDisplayNameSnapshot != null)
        'exercise_display_name_snapshot': exerciseDisplayNameSnapshot,
      if (catalogVersionSnapshot != null)
        'catalog_version_snapshot': catalogVersionSnapshot,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutGroupExerciseAssignmentsCompanion copyWith({
    Value<String>? assignmentId,
    Value<String>? workoutGroupId,
    Value<String>? exerciseSource,
    Value<String>? exerciseId,
    Value<String>? exerciseDisplayNameSnapshot,
    Value<String?>? catalogVersionSnapshot,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return WorkoutGroupExerciseAssignmentsCompanion(
      assignmentId: assignmentId ?? this.assignmentId,
      workoutGroupId: workoutGroupId ?? this.workoutGroupId,
      exerciseSource: exerciseSource ?? this.exerciseSource,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseDisplayNameSnapshot:
          exerciseDisplayNameSnapshot ?? this.exerciseDisplayNameSnapshot,
      catalogVersionSnapshot:
          catalogVersionSnapshot ?? this.catalogVersionSnapshot,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assignmentId.present) {
      map['assignment_id'] = Variable<String>(assignmentId.value);
    }
    if (workoutGroupId.present) {
      map['workout_group_id'] = Variable<String>(workoutGroupId.value);
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
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutGroupExerciseAssignmentsCompanion(')
          ..write('assignmentId: $assignmentId, ')
          ..write('workoutGroupId: $workoutGroupId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseDisplayNameSnapshot: $exerciseDisplayNameSnapshot, ')
          ..write('catalogVersionSnapshot: $catalogVersionSnapshot, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsProfilesTable extends SettingsProfiles
    with TableInfo<$SettingsProfilesTable, SettingsProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(profile_id) > 0)',
  );
  static const VerificationMeta _languageOverrideMeta = const VerificationMeta(
    'languageOverride',
  );
  @override
  late final GeneratedColumn<String> languageOverride = GeneratedColumn<String>(
    'language_override',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (language_override IN (\'system\', \'en\', \'de\'))',
  );
  static const VerificationMeta _unitPreferenceMeta = const VerificationMeta(
    'unitPreference',
  );
  @override
  late final GeneratedColumn<String> unitPreference = GeneratedColumn<String>(
    'unit_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (unit_preference IN (\'metric\', \'imperial\'))',
  );
  static const VerificationMeta _themePreferenceMeta = const VerificationMeta(
    'themePreference',
  );
  @override
  late final GeneratedColumn<String> themePreference = GeneratedColumn<String>(
    'theme_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (theme_preference IN (\'system\', \'dark\', \'light\'))',
  );
  static const VerificationMeta _defaultRestSecondsMeta =
      const VerificationMeta('defaultRestSeconds');
  @override
  late final GeneratedColumn<int> defaultRestSeconds = GeneratedColumn<int>(
    'default_rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (default_rest_seconds > 0 AND default_rest_seconds <= 1800)',
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NULL CHECK (display_name IS NULL OR (length(display_name) > 0 AND length(display_name) <= 80))',
  );
  static const VerificationMeta _focusProfileMeta = const VerificationMeta(
    'focusProfile',
  );
  @override
  late final GeneratedColumn<String> focusProfile = GeneratedColumn<String>(
    'focus_profile',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (focus_profile IN (\'balanced\', \'upperBodyFocus\', \'lowerBodyGluteFocus\', \'armsChestFocus\', \'strengthBasics\', \'timeEfficient\', \'beginnerFoundation\', \'custom\'))',
  );
  static const VerificationMeta _trainingDaysPerWeekMeta =
      const VerificationMeta('trainingDaysPerWeek');
  @override
  late final GeneratedColumn<int> trainingDaysPerWeek = GeneratedColumn<int>(
    'training_days_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (training_days_per_week BETWEEN 1 AND 7)',
  );
  static const VerificationMeta _sessionDurationMinutesMeta =
      const VerificationMeta('sessionDurationMinutes');
  @override
  late final GeneratedColumn<int> sessionDurationMinutes = GeneratedColumn<int>(
    'session_duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (session_duration_minutes IN (15, 25, 35, 45, 60, 75))',
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    languageOverride,
    unitPreference,
    themePreference,
    defaultRestSeconds,
    displayName,
    focusProfile,
    trainingDaysPerWeek,
    sessionDurationMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('language_override')) {
      context.handle(
        _languageOverrideMeta,
        languageOverride.isAcceptableOrUnknown(
          data['language_override']!,
          _languageOverrideMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageOverrideMeta);
    }
    if (data.containsKey('unit_preference')) {
      context.handle(
        _unitPreferenceMeta,
        unitPreference.isAcceptableOrUnknown(
          data['unit_preference']!,
          _unitPreferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPreferenceMeta);
    }
    if (data.containsKey('theme_preference')) {
      context.handle(
        _themePreferenceMeta,
        themePreference.isAcceptableOrUnknown(
          data['theme_preference']!,
          _themePreferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_themePreferenceMeta);
    }
    if (data.containsKey('default_rest_seconds')) {
      context.handle(
        _defaultRestSecondsMeta,
        defaultRestSeconds.isAcceptableOrUnknown(
          data['default_rest_seconds']!,
          _defaultRestSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultRestSecondsMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('focus_profile')) {
      context.handle(
        _focusProfileMeta,
        focusProfile.isAcceptableOrUnknown(
          data['focus_profile']!,
          _focusProfileMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_focusProfileMeta);
    }
    if (data.containsKey('training_days_per_week')) {
      context.handle(
        _trainingDaysPerWeekMeta,
        trainingDaysPerWeek.isAcceptableOrUnknown(
          data['training_days_per_week']!,
          _trainingDaysPerWeekMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trainingDaysPerWeekMeta);
    }
    if (data.containsKey('session_duration_minutes')) {
      context.handle(
        _sessionDurationMinutesMeta,
        sessionDurationMinutes.isAcceptableOrUnknown(
          data['session_duration_minutes']!,
          _sessionDurationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionDurationMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  SettingsProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsProfileRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      languageOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_override'],
      )!,
      unitPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_preference'],
      )!,
      themePreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_preference'],
      )!,
      defaultRestSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_rest_seconds'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      focusProfile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus_profile'],
      )!,
      trainingDaysPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}training_days_per_week'],
      )!,
      sessionDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_duration_minutes'],
      )!,
    );
  }

  @override
  $SettingsProfilesTable createAlias(String alias) {
    return $SettingsProfilesTable(attachedDatabase, alias);
  }
}

class SettingsProfileRow extends DataClass
    implements Insertable<SettingsProfileRow> {
  final String profileId;
  final String languageOverride;
  final String unitPreference;
  final String themePreference;
  final int defaultRestSeconds;
  final String? displayName;
  final String focusProfile;
  final int trainingDaysPerWeek;
  final int sessionDurationMinutes;
  const SettingsProfileRow({
    required this.profileId,
    required this.languageOverride,
    required this.unitPreference,
    required this.themePreference,
    required this.defaultRestSeconds,
    this.displayName,
    required this.focusProfile,
    required this.trainingDaysPerWeek,
    required this.sessionDurationMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['language_override'] = Variable<String>(languageOverride);
    map['unit_preference'] = Variable<String>(unitPreference);
    map['theme_preference'] = Variable<String>(themePreference);
    map['default_rest_seconds'] = Variable<int>(defaultRestSeconds);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['focus_profile'] = Variable<String>(focusProfile);
    map['training_days_per_week'] = Variable<int>(trainingDaysPerWeek);
    map['session_duration_minutes'] = Variable<int>(sessionDurationMinutes);
    return map;
  }

  SettingsProfilesCompanion toCompanion(bool nullToAbsent) {
    return SettingsProfilesCompanion(
      profileId: Value(profileId),
      languageOverride: Value(languageOverride),
      unitPreference: Value(unitPreference),
      themePreference: Value(themePreference),
      defaultRestSeconds: Value(defaultRestSeconds),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      focusProfile: Value(focusProfile),
      trainingDaysPerWeek: Value(trainingDaysPerWeek),
      sessionDurationMinutes: Value(sessionDurationMinutes),
    );
  }

  factory SettingsProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsProfileRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      languageOverride: serializer.fromJson<String>(json['languageOverride']),
      unitPreference: serializer.fromJson<String>(json['unitPreference']),
      themePreference: serializer.fromJson<String>(json['themePreference']),
      defaultRestSeconds: serializer.fromJson<int>(json['defaultRestSeconds']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      focusProfile: serializer.fromJson<String>(json['focusProfile']),
      trainingDaysPerWeek: serializer.fromJson<int>(
        json['trainingDaysPerWeek'],
      ),
      sessionDurationMinutes: serializer.fromJson<int>(
        json['sessionDurationMinutes'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'languageOverride': serializer.toJson<String>(languageOverride),
      'unitPreference': serializer.toJson<String>(unitPreference),
      'themePreference': serializer.toJson<String>(themePreference),
      'defaultRestSeconds': serializer.toJson<int>(defaultRestSeconds),
      'displayName': serializer.toJson<String?>(displayName),
      'focusProfile': serializer.toJson<String>(focusProfile),
      'trainingDaysPerWeek': serializer.toJson<int>(trainingDaysPerWeek),
      'sessionDurationMinutes': serializer.toJson<int>(sessionDurationMinutes),
    };
  }

  SettingsProfileRow copyWith({
    String? profileId,
    String? languageOverride,
    String? unitPreference,
    String? themePreference,
    int? defaultRestSeconds,
    Value<String?> displayName = const Value.absent(),
    String? focusProfile,
    int? trainingDaysPerWeek,
    int? sessionDurationMinutes,
  }) => SettingsProfileRow(
    profileId: profileId ?? this.profileId,
    languageOverride: languageOverride ?? this.languageOverride,
    unitPreference: unitPreference ?? this.unitPreference,
    themePreference: themePreference ?? this.themePreference,
    defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
    displayName: displayName.present ? displayName.value : this.displayName,
    focusProfile: focusProfile ?? this.focusProfile,
    trainingDaysPerWeek: trainingDaysPerWeek ?? this.trainingDaysPerWeek,
    sessionDurationMinutes:
        sessionDurationMinutes ?? this.sessionDurationMinutes,
  );
  SettingsProfileRow copyWithCompanion(SettingsProfilesCompanion data) {
    return SettingsProfileRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      languageOverride: data.languageOverride.present
          ? data.languageOverride.value
          : this.languageOverride,
      unitPreference: data.unitPreference.present
          ? data.unitPreference.value
          : this.unitPreference,
      themePreference: data.themePreference.present
          ? data.themePreference.value
          : this.themePreference,
      defaultRestSeconds: data.defaultRestSeconds.present
          ? data.defaultRestSeconds.value
          : this.defaultRestSeconds,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      focusProfile: data.focusProfile.present
          ? data.focusProfile.value
          : this.focusProfile,
      trainingDaysPerWeek: data.trainingDaysPerWeek.present
          ? data.trainingDaysPerWeek.value
          : this.trainingDaysPerWeek,
      sessionDurationMinutes: data.sessionDurationMinutes.present
          ? data.sessionDurationMinutes.value
          : this.sessionDurationMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsProfileRow(')
          ..write('profileId: $profileId, ')
          ..write('languageOverride: $languageOverride, ')
          ..write('unitPreference: $unitPreference, ')
          ..write('themePreference: $themePreference, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('displayName: $displayName, ')
          ..write('focusProfile: $focusProfile, ')
          ..write('trainingDaysPerWeek: $trainingDaysPerWeek, ')
          ..write('sessionDurationMinutes: $sessionDurationMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    languageOverride,
    unitPreference,
    themePreference,
    defaultRestSeconds,
    displayName,
    focusProfile,
    trainingDaysPerWeek,
    sessionDurationMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsProfileRow &&
          other.profileId == this.profileId &&
          other.languageOverride == this.languageOverride &&
          other.unitPreference == this.unitPreference &&
          other.themePreference == this.themePreference &&
          other.defaultRestSeconds == this.defaultRestSeconds &&
          other.displayName == this.displayName &&
          other.focusProfile == this.focusProfile &&
          other.trainingDaysPerWeek == this.trainingDaysPerWeek &&
          other.sessionDurationMinutes == this.sessionDurationMinutes);
}

class SettingsProfilesCompanion extends UpdateCompanion<SettingsProfileRow> {
  final Value<String> profileId;
  final Value<String> languageOverride;
  final Value<String> unitPreference;
  final Value<String> themePreference;
  final Value<int> defaultRestSeconds;
  final Value<String?> displayName;
  final Value<String> focusProfile;
  final Value<int> trainingDaysPerWeek;
  final Value<int> sessionDurationMinutes;
  final Value<int> rowid;
  const SettingsProfilesCompanion({
    this.profileId = const Value.absent(),
    this.languageOverride = const Value.absent(),
    this.unitPreference = const Value.absent(),
    this.themePreference = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.displayName = const Value.absent(),
    this.focusProfile = const Value.absent(),
    this.trainingDaysPerWeek = const Value.absent(),
    this.sessionDurationMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsProfilesCompanion.insert({
    required String profileId,
    required String languageOverride,
    required String unitPreference,
    required String themePreference,
    required int defaultRestSeconds,
    this.displayName = const Value.absent(),
    required String focusProfile,
    required int trainingDaysPerWeek,
    required int sessionDurationMinutes,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       languageOverride = Value(languageOverride),
       unitPreference = Value(unitPreference),
       themePreference = Value(themePreference),
       defaultRestSeconds = Value(defaultRestSeconds),
       focusProfile = Value(focusProfile),
       trainingDaysPerWeek = Value(trainingDaysPerWeek),
       sessionDurationMinutes = Value(sessionDurationMinutes);
  static Insertable<SettingsProfileRow> custom({
    Expression<String>? profileId,
    Expression<String>? languageOverride,
    Expression<String>? unitPreference,
    Expression<String>? themePreference,
    Expression<int>? defaultRestSeconds,
    Expression<String>? displayName,
    Expression<String>? focusProfile,
    Expression<int>? trainingDaysPerWeek,
    Expression<int>? sessionDurationMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (languageOverride != null) 'language_override': languageOverride,
      if (unitPreference != null) 'unit_preference': unitPreference,
      if (themePreference != null) 'theme_preference': themePreference,
      if (defaultRestSeconds != null)
        'default_rest_seconds': defaultRestSeconds,
      if (displayName != null) 'display_name': displayName,
      if (focusProfile != null) 'focus_profile': focusProfile,
      if (trainingDaysPerWeek != null)
        'training_days_per_week': trainingDaysPerWeek,
      if (sessionDurationMinutes != null)
        'session_duration_minutes': sessionDurationMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsProfilesCompanion copyWith({
    Value<String>? profileId,
    Value<String>? languageOverride,
    Value<String>? unitPreference,
    Value<String>? themePreference,
    Value<int>? defaultRestSeconds,
    Value<String?>? displayName,
    Value<String>? focusProfile,
    Value<int>? trainingDaysPerWeek,
    Value<int>? sessionDurationMinutes,
    Value<int>? rowid,
  }) {
    return SettingsProfilesCompanion(
      profileId: profileId ?? this.profileId,
      languageOverride: languageOverride ?? this.languageOverride,
      unitPreference: unitPreference ?? this.unitPreference,
      themePreference: themePreference ?? this.themePreference,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      displayName: displayName ?? this.displayName,
      focusProfile: focusProfile ?? this.focusProfile,
      trainingDaysPerWeek: trainingDaysPerWeek ?? this.trainingDaysPerWeek,
      sessionDurationMinutes:
          sessionDurationMinutes ?? this.sessionDurationMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (languageOverride.present) {
      map['language_override'] = Variable<String>(languageOverride.value);
    }
    if (unitPreference.present) {
      map['unit_preference'] = Variable<String>(unitPreference.value);
    }
    if (themePreference.present) {
      map['theme_preference'] = Variable<String>(themePreference.value);
    }
    if (defaultRestSeconds.present) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (focusProfile.present) {
      map['focus_profile'] = Variable<String>(focusProfile.value);
    }
    if (trainingDaysPerWeek.present) {
      map['training_days_per_week'] = Variable<int>(trainingDaysPerWeek.value);
    }
    if (sessionDurationMinutes.present) {
      map['session_duration_minutes'] = Variable<int>(
        sessionDurationMinutes.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsProfilesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('languageOverride: $languageOverride, ')
          ..write('unitPreference: $unitPreference, ')
          ..write('themePreference: $themePreference, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('displayName: $displayName, ')
          ..write('focusProfile: $focusProfile, ')
          ..write('trainingDaysPerWeek: $trainingDaysPerWeek, ')
          ..write('sessionDurationMinutes: $sessionDurationMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquipmentInventoryItemsTable extends EquipmentInventoryItems
    with TableInfo<$EquipmentInventoryItemsTable, EquipmentInventoryItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentInventoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(profile_id) > 0)',
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (equipment IN (\'bodyweight\', \'barbell\', \'dumbbell\', \'cable\', \'machine\', \'smithMachine\', \'pullUpBar\', \'bench\', \'legPress\'))',
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, equipment];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_inventory_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentInventoryItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, equipment};
  @override
  EquipmentInventoryItemRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentInventoryItemRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
    );
  }

  @override
  $EquipmentInventoryItemsTable createAlias(String alias) {
    return $EquipmentInventoryItemsTable(attachedDatabase, alias);
  }
}

class EquipmentInventoryItemRow extends DataClass
    implements Insertable<EquipmentInventoryItemRow> {
  final String profileId;
  final String equipment;
  const EquipmentInventoryItemRow({
    required this.profileId,
    required this.equipment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['equipment'] = Variable<String>(equipment);
    return map;
  }

  EquipmentInventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return EquipmentInventoryItemsCompanion(
      profileId: Value(profileId),
      equipment: Value(equipment),
    );
  }

  factory EquipmentInventoryItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentInventoryItemRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      equipment: serializer.fromJson<String>(json['equipment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'equipment': serializer.toJson<String>(equipment),
    };
  }

  EquipmentInventoryItemRow copyWith({String? profileId, String? equipment}) =>
      EquipmentInventoryItemRow(
        profileId: profileId ?? this.profileId,
        equipment: equipment ?? this.equipment,
      );
  EquipmentInventoryItemRow copyWithCompanion(
    EquipmentInventoryItemsCompanion data,
  ) {
    return EquipmentInventoryItemRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentInventoryItemRow(')
          ..write('profileId: $profileId, ')
          ..write('equipment: $equipment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, equipment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentInventoryItemRow &&
          other.profileId == this.profileId &&
          other.equipment == this.equipment);
}

class EquipmentInventoryItemsCompanion
    extends UpdateCompanion<EquipmentInventoryItemRow> {
  final Value<String> profileId;
  final Value<String> equipment;
  final Value<int> rowid;
  const EquipmentInventoryItemsCompanion({
    this.profileId = const Value.absent(),
    this.equipment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EquipmentInventoryItemsCompanion.insert({
    required String profileId,
    required String equipment,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       equipment = Value(equipment);
  static Insertable<EquipmentInventoryItemRow> custom({
    Expression<String>? profileId,
    Expression<String>? equipment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (equipment != null) 'equipment': equipment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EquipmentInventoryItemsCompanion copyWith({
    Value<String>? profileId,
    Value<String>? equipment,
    Value<int>? rowid,
  }) {
    return EquipmentInventoryItemsCompanion(
      profileId: profileId ?? this.profileId,
      equipment: equipment ?? this.equipment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentInventoryItemsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('equipment: $equipment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OnboardingStatusesTable extends OnboardingStatuses
    with TableInfo<$OnboardingStatusesTable, OnboardingStatusRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnboardingStatusesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _statusIdMeta = const VerificationMeta(
    'statusId',
  );
  @override
  late final GeneratedColumn<String> statusId = GeneratedColumn<String>(
    'status_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(status_id) > 0)',
  );
  static const VerificationMeta _completionMeta = const VerificationMeta(
    'completion',
  );
  @override
  late final GeneratedColumn<String> completion = GeneratedColumn<String>(
    'completion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (completion IN (\'notStarted\', \'skipped\', \'completed\'))',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [statusId, completion, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'onboarding_statuses';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnboardingStatusRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('status_id')) {
      context.handle(
        _statusIdMeta,
        statusId.isAcceptableOrUnknown(data['status_id']!, _statusIdMeta),
      );
    } else if (isInserting) {
      context.missing(_statusIdMeta);
    }
    if (data.containsKey('completion')) {
      context.handle(
        _completionMeta,
        completion.isAcceptableOrUnknown(data['completion']!, _completionMeta),
      );
    } else if (isInserting) {
      context.missing(_completionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {statusId};
  @override
  OnboardingStatusRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnboardingStatusRow(
      statusId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_id'],
      )!,
      completion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OnboardingStatusesTable createAlias(String alias) {
    return $OnboardingStatusesTable(attachedDatabase, alias);
  }
}

class OnboardingStatusRow extends DataClass
    implements Insertable<OnboardingStatusRow> {
  final String statusId;
  final String completion;
  final DateTime updatedAt;
  const OnboardingStatusRow({
    required this.statusId,
    required this.completion,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['status_id'] = Variable<String>(statusId);
    map['completion'] = Variable<String>(completion);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OnboardingStatusesCompanion toCompanion(bool nullToAbsent) {
    return OnboardingStatusesCompanion(
      statusId: Value(statusId),
      completion: Value(completion),
      updatedAt: Value(updatedAt),
    );
  }

  factory OnboardingStatusRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnboardingStatusRow(
      statusId: serializer.fromJson<String>(json['statusId']),
      completion: serializer.fromJson<String>(json['completion']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'statusId': serializer.toJson<String>(statusId),
      'completion': serializer.toJson<String>(completion),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OnboardingStatusRow copyWith({
    String? statusId,
    String? completion,
    DateTime? updatedAt,
  }) => OnboardingStatusRow(
    statusId: statusId ?? this.statusId,
    completion: completion ?? this.completion,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OnboardingStatusRow copyWithCompanion(OnboardingStatusesCompanion data) {
    return OnboardingStatusRow(
      statusId: data.statusId.present ? data.statusId.value : this.statusId,
      completion: data.completion.present
          ? data.completion.value
          : this.completion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingStatusRow(')
          ..write('statusId: $statusId, ')
          ..write('completion: $completion, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(statusId, completion, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnboardingStatusRow &&
          other.statusId == this.statusId &&
          other.completion == this.completion &&
          other.updatedAt == this.updatedAt);
}

class OnboardingStatusesCompanion extends UpdateCompanion<OnboardingStatusRow> {
  final Value<String> statusId;
  final Value<String> completion;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OnboardingStatusesCompanion({
    this.statusId = const Value.absent(),
    this.completion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OnboardingStatusesCompanion.insert({
    required String statusId,
    required String completion,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : statusId = Value(statusId),
       completion = Value(completion),
       updatedAt = Value(updatedAt);
  static Insertable<OnboardingStatusRow> custom({
    Expression<String>? statusId,
    Expression<String>? completion,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (statusId != null) 'status_id': statusId,
      if (completion != null) 'completion': completion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OnboardingStatusesCompanion copyWith({
    Value<String>? statusId,
    Value<String>? completion,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OnboardingStatusesCompanion(
      statusId: statusId ?? this.statusId,
      completion: completion ?? this.completion,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (statusId.present) {
      map['status_id'] = Variable<String>(statusId.value);
    }
    if (completion.present) {
      map['completion'] = Variable<String>(completion.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingStatusesCompanion(')
          ..write('statusId: $statusId, ')
          ..write('completion: $completion, ')
          ..write('updatedAt: $updatedAt, ')
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
  late final $WorkoutGroupsTable workoutGroups = $WorkoutGroupsTable(this);
  late final $WorkoutGroupExerciseAssignmentsTable
  workoutGroupExerciseAssignments = $WorkoutGroupExerciseAssignmentsTable(this);
  late final $SettingsProfilesTable settingsProfiles = $SettingsProfilesTable(
    this,
  );
  late final $EquipmentInventoryItemsTable equipmentInventoryItems =
      $EquipmentInventoryItemsTable(this);
  late final $OnboardingStatusesTable onboardingStatuses =
      $OnboardingStatusesTable(this);
  late final Index workoutSetsExerciseTimelineIdx = Index(
    'workout_sets_exercise_timeline_idx',
    'CREATE INDEX workout_sets_exercise_timeline_idx ON workout_sets (exercise_source, exercise_id, performed_at DESC, workout_set_id DESC)',
  );
  late final Index workoutSetsHistoryOrderIdx = Index(
    'workout_sets_history_order_idx',
    'CREATE INDEX workout_sets_history_order_idx ON workout_sets (performed_at DESC, workout_set_id DESC)',
  );
  late final Index workoutSetsSessionOrderIdx = Index(
    'workout_sets_session_order_idx',
    'CREATE INDEX workout_sets_session_order_idx ON workout_sets (workout_session_id, performed_at, workout_set_id)',
  );
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
    workoutGroups,
    workoutGroupExerciseAssignments,
    settingsProfiles,
    equipmentInventoryItems,
    onboardingStatuses,
    workoutSetsExerciseTimelineIdx,
    workoutSetsHistoryOrderIdx,
    workoutSetsSessionOrderIdx,
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
      Value<String?> setLabel,
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
      Value<String?> setLabel,
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

  ColumnFilters<String> get setLabel => $composableBuilder(
    column: $table.setLabel,
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

  ColumnOrderings<String> get setLabel => $composableBuilder(
    column: $table.setLabel,
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

  GeneratedColumn<String> get setLabel =>
      $composableBuilder(column: $table.setLabel, builder: (column) => column);
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
                Value<String?> setLabel = const Value.absent(),
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
                setLabel: setLabel,
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
                Value<String?> setLabel = const Value.absent(),
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
                setLabel: setLabel,
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
typedef $$WorkoutGroupsTableCreateCompanionBuilder =
    WorkoutGroupsCompanion Function({
      required String workoutGroupId,
      required String name,
      required int sortOrder,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$WorkoutGroupsTableUpdateCompanionBuilder =
    WorkoutGroupsCompanion Function({
      Value<String> workoutGroupId,
      Value<String> name,
      Value<int> sortOrder,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

class $$WorkoutGroupsTableFilterComposer
    extends Composer<_$RepForgeDatabase, $WorkoutGroupsTable> {
  $$WorkoutGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get workoutGroupId => $composableBuilder(
    column: $table.workoutGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutGroupsTableOrderingComposer
    extends Composer<_$RepForgeDatabase, $WorkoutGroupsTable> {
  $$WorkoutGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get workoutGroupId => $composableBuilder(
    column: $table.workoutGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutGroupsTableAnnotationComposer
    extends Composer<_$RepForgeDatabase, $WorkoutGroupsTable> {
  $$WorkoutGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get workoutGroupId => $composableBuilder(
    column: $table.workoutGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );
}

class $$WorkoutGroupsTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $WorkoutGroupsTable,
          WorkoutGroupRow,
          $$WorkoutGroupsTableFilterComposer,
          $$WorkoutGroupsTableOrderingComposer,
          $$WorkoutGroupsTableAnnotationComposer,
          $$WorkoutGroupsTableCreateCompanionBuilder,
          $$WorkoutGroupsTableUpdateCompanionBuilder,
          (
            WorkoutGroupRow,
            BaseReferences<
              _$RepForgeDatabase,
              $WorkoutGroupsTable,
              WorkoutGroupRow
            >,
          ),
          WorkoutGroupRow,
          PrefetchHooks Function()
        > {
  $$WorkoutGroupsTableTableManager(
    _$RepForgeDatabase db,
    $WorkoutGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> workoutGroupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutGroupsCompanion(
                workoutGroupId: workoutGroupId,
                name: name,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String workoutGroupId,
                required String name,
                required int sortOrder,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutGroupsCompanion.insert(
                workoutGroupId: workoutGroupId,
                name: name,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $WorkoutGroupsTable,
      WorkoutGroupRow,
      $$WorkoutGroupsTableFilterComposer,
      $$WorkoutGroupsTableOrderingComposer,
      $$WorkoutGroupsTableAnnotationComposer,
      $$WorkoutGroupsTableCreateCompanionBuilder,
      $$WorkoutGroupsTableUpdateCompanionBuilder,
      (
        WorkoutGroupRow,
        BaseReferences<
          _$RepForgeDatabase,
          $WorkoutGroupsTable,
          WorkoutGroupRow
        >,
      ),
      WorkoutGroupRow,
      PrefetchHooks Function()
    >;
typedef $$WorkoutGroupExerciseAssignmentsTableCreateCompanionBuilder =
    WorkoutGroupExerciseAssignmentsCompanion Function({
      required String assignmentId,
      required String workoutGroupId,
      required String exerciseSource,
      required String exerciseId,
      required String exerciseDisplayNameSnapshot,
      Value<String?> catalogVersionSnapshot,
      required int position,
      Value<int> rowid,
    });
typedef $$WorkoutGroupExerciseAssignmentsTableUpdateCompanionBuilder =
    WorkoutGroupExerciseAssignmentsCompanion Function({
      Value<String> assignmentId,
      Value<String> workoutGroupId,
      Value<String> exerciseSource,
      Value<String> exerciseId,
      Value<String> exerciseDisplayNameSnapshot,
      Value<String?> catalogVersionSnapshot,
      Value<int> position,
      Value<int> rowid,
    });

class $$WorkoutGroupExerciseAssignmentsTableFilterComposer
    extends
        Composer<_$RepForgeDatabase, $WorkoutGroupExerciseAssignmentsTable> {
  $$WorkoutGroupExerciseAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutGroupId => $composableBuilder(
    column: $table.workoutGroupId,
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

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutGroupExerciseAssignmentsTableOrderingComposer
    extends
        Composer<_$RepForgeDatabase, $WorkoutGroupExerciseAssignmentsTable> {
  $$WorkoutGroupExerciseAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutGroupId => $composableBuilder(
    column: $table.workoutGroupId,
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

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutGroupExerciseAssignmentsTableAnnotationComposer
    extends
        Composer<_$RepForgeDatabase, $WorkoutGroupExerciseAssignmentsTable> {
  $$WorkoutGroupExerciseAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workoutGroupId => $composableBuilder(
    column: $table.workoutGroupId,
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

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$WorkoutGroupExerciseAssignmentsTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $WorkoutGroupExerciseAssignmentsTable,
          WorkoutGroupExerciseAssignmentRow,
          $$WorkoutGroupExerciseAssignmentsTableFilterComposer,
          $$WorkoutGroupExerciseAssignmentsTableOrderingComposer,
          $$WorkoutGroupExerciseAssignmentsTableAnnotationComposer,
          $$WorkoutGroupExerciseAssignmentsTableCreateCompanionBuilder,
          $$WorkoutGroupExerciseAssignmentsTableUpdateCompanionBuilder,
          (
            WorkoutGroupExerciseAssignmentRow,
            BaseReferences<
              _$RepForgeDatabase,
              $WorkoutGroupExerciseAssignmentsTable,
              WorkoutGroupExerciseAssignmentRow
            >,
          ),
          WorkoutGroupExerciseAssignmentRow,
          PrefetchHooks Function()
        > {
  $$WorkoutGroupExerciseAssignmentsTableTableManager(
    _$RepForgeDatabase db,
    $WorkoutGroupExerciseAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutGroupExerciseAssignmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WorkoutGroupExerciseAssignmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutGroupExerciseAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> assignmentId = const Value.absent(),
                Value<String> workoutGroupId = const Value.absent(),
                Value<String> exerciseSource = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> exerciseDisplayNameSnapshot =
                    const Value.absent(),
                Value<String?> catalogVersionSnapshot = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutGroupExerciseAssignmentsCompanion(
                assignmentId: assignmentId,
                workoutGroupId: workoutGroupId,
                exerciseSource: exerciseSource,
                exerciseId: exerciseId,
                exerciseDisplayNameSnapshot: exerciseDisplayNameSnapshot,
                catalogVersionSnapshot: catalogVersionSnapshot,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String assignmentId,
                required String workoutGroupId,
                required String exerciseSource,
                required String exerciseId,
                required String exerciseDisplayNameSnapshot,
                Value<String?> catalogVersionSnapshot = const Value.absent(),
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutGroupExerciseAssignmentsCompanion.insert(
                assignmentId: assignmentId,
                workoutGroupId: workoutGroupId,
                exerciseSource: exerciseSource,
                exerciseId: exerciseId,
                exerciseDisplayNameSnapshot: exerciseDisplayNameSnapshot,
                catalogVersionSnapshot: catalogVersionSnapshot,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutGroupExerciseAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $WorkoutGroupExerciseAssignmentsTable,
      WorkoutGroupExerciseAssignmentRow,
      $$WorkoutGroupExerciseAssignmentsTableFilterComposer,
      $$WorkoutGroupExerciseAssignmentsTableOrderingComposer,
      $$WorkoutGroupExerciseAssignmentsTableAnnotationComposer,
      $$WorkoutGroupExerciseAssignmentsTableCreateCompanionBuilder,
      $$WorkoutGroupExerciseAssignmentsTableUpdateCompanionBuilder,
      (
        WorkoutGroupExerciseAssignmentRow,
        BaseReferences<
          _$RepForgeDatabase,
          $WorkoutGroupExerciseAssignmentsTable,
          WorkoutGroupExerciseAssignmentRow
        >,
      ),
      WorkoutGroupExerciseAssignmentRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsProfilesTableCreateCompanionBuilder =
    SettingsProfilesCompanion Function({
      required String profileId,
      required String languageOverride,
      required String unitPreference,
      required String themePreference,
      required int defaultRestSeconds,
      Value<String?> displayName,
      required String focusProfile,
      required int trainingDaysPerWeek,
      required int sessionDurationMinutes,
      Value<int> rowid,
    });
typedef $$SettingsProfilesTableUpdateCompanionBuilder =
    SettingsProfilesCompanion Function({
      Value<String> profileId,
      Value<String> languageOverride,
      Value<String> unitPreference,
      Value<String> themePreference,
      Value<int> defaultRestSeconds,
      Value<String?> displayName,
      Value<String> focusProfile,
      Value<int> trainingDaysPerWeek,
      Value<int> sessionDurationMinutes,
      Value<int> rowid,
    });

class $$SettingsProfilesTableFilterComposer
    extends Composer<_$RepForgeDatabase, $SettingsProfilesTable> {
  $$SettingsProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageOverride => $composableBuilder(
    column: $table.languageOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitPreference => $composableBuilder(
    column: $table.unitPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focusProfile => $composableBuilder(
    column: $table.focusProfile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trainingDaysPerWeek => $composableBuilder(
    column: $table.trainingDaysPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionDurationMinutes => $composableBuilder(
    column: $table.sessionDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsProfilesTableOrderingComposer
    extends Composer<_$RepForgeDatabase, $SettingsProfilesTable> {
  $$SettingsProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageOverride => $composableBuilder(
    column: $table.languageOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitPreference => $composableBuilder(
    column: $table.unitPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focusProfile => $composableBuilder(
    column: $table.focusProfile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trainingDaysPerWeek => $composableBuilder(
    column: $table.trainingDaysPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionDurationMinutes => $composableBuilder(
    column: $table.sessionDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsProfilesTableAnnotationComposer
    extends Composer<_$RepForgeDatabase, $SettingsProfilesTable> {
  $$SettingsProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get languageOverride => $composableBuilder(
    column: $table.languageOverride,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitPreference => $composableBuilder(
    column: $table.unitPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get focusProfile => $composableBuilder(
    column: $table.focusProfile,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trainingDaysPerWeek => $composableBuilder(
    column: $table.trainingDaysPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionDurationMinutes => $composableBuilder(
    column: $table.sessionDurationMinutes,
    builder: (column) => column,
  );
}

class $$SettingsProfilesTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $SettingsProfilesTable,
          SettingsProfileRow,
          $$SettingsProfilesTableFilterComposer,
          $$SettingsProfilesTableOrderingComposer,
          $$SettingsProfilesTableAnnotationComposer,
          $$SettingsProfilesTableCreateCompanionBuilder,
          $$SettingsProfilesTableUpdateCompanionBuilder,
          (
            SettingsProfileRow,
            BaseReferences<
              _$RepForgeDatabase,
              $SettingsProfilesTable,
              SettingsProfileRow
            >,
          ),
          SettingsProfileRow,
          PrefetchHooks Function()
        > {
  $$SettingsProfilesTableTableManager(
    _$RepForgeDatabase db,
    $SettingsProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> languageOverride = const Value.absent(),
                Value<String> unitPreference = const Value.absent(),
                Value<String> themePreference = const Value.absent(),
                Value<int> defaultRestSeconds = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String> focusProfile = const Value.absent(),
                Value<int> trainingDaysPerWeek = const Value.absent(),
                Value<int> sessionDurationMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsProfilesCompanion(
                profileId: profileId,
                languageOverride: languageOverride,
                unitPreference: unitPreference,
                themePreference: themePreference,
                defaultRestSeconds: defaultRestSeconds,
                displayName: displayName,
                focusProfile: focusProfile,
                trainingDaysPerWeek: trainingDaysPerWeek,
                sessionDurationMinutes: sessionDurationMinutes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String languageOverride,
                required String unitPreference,
                required String themePreference,
                required int defaultRestSeconds,
                Value<String?> displayName = const Value.absent(),
                required String focusProfile,
                required int trainingDaysPerWeek,
                required int sessionDurationMinutes,
                Value<int> rowid = const Value.absent(),
              }) => SettingsProfilesCompanion.insert(
                profileId: profileId,
                languageOverride: languageOverride,
                unitPreference: unitPreference,
                themePreference: themePreference,
                defaultRestSeconds: defaultRestSeconds,
                displayName: displayName,
                focusProfile: focusProfile,
                trainingDaysPerWeek: trainingDaysPerWeek,
                sessionDurationMinutes: sessionDurationMinutes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $SettingsProfilesTable,
      SettingsProfileRow,
      $$SettingsProfilesTableFilterComposer,
      $$SettingsProfilesTableOrderingComposer,
      $$SettingsProfilesTableAnnotationComposer,
      $$SettingsProfilesTableCreateCompanionBuilder,
      $$SettingsProfilesTableUpdateCompanionBuilder,
      (
        SettingsProfileRow,
        BaseReferences<
          _$RepForgeDatabase,
          $SettingsProfilesTable,
          SettingsProfileRow
        >,
      ),
      SettingsProfileRow,
      PrefetchHooks Function()
    >;
typedef $$EquipmentInventoryItemsTableCreateCompanionBuilder =
    EquipmentInventoryItemsCompanion Function({
      required String profileId,
      required String equipment,
      Value<int> rowid,
    });
typedef $$EquipmentInventoryItemsTableUpdateCompanionBuilder =
    EquipmentInventoryItemsCompanion Function({
      Value<String> profileId,
      Value<String> equipment,
      Value<int> rowid,
    });

class $$EquipmentInventoryItemsTableFilterComposer
    extends Composer<_$RepForgeDatabase, $EquipmentInventoryItemsTable> {
  $$EquipmentInventoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquipmentInventoryItemsTableOrderingComposer
    extends Composer<_$RepForgeDatabase, $EquipmentInventoryItemsTable> {
  $$EquipmentInventoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentInventoryItemsTableAnnotationComposer
    extends Composer<_$RepForgeDatabase, $EquipmentInventoryItemsTable> {
  $$EquipmentInventoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);
}

class $$EquipmentInventoryItemsTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $EquipmentInventoryItemsTable,
          EquipmentInventoryItemRow,
          $$EquipmentInventoryItemsTableFilterComposer,
          $$EquipmentInventoryItemsTableOrderingComposer,
          $$EquipmentInventoryItemsTableAnnotationComposer,
          $$EquipmentInventoryItemsTableCreateCompanionBuilder,
          $$EquipmentInventoryItemsTableUpdateCompanionBuilder,
          (
            EquipmentInventoryItemRow,
            BaseReferences<
              _$RepForgeDatabase,
              $EquipmentInventoryItemsTable,
              EquipmentInventoryItemRow
            >,
          ),
          EquipmentInventoryItemRow,
          PrefetchHooks Function()
        > {
  $$EquipmentInventoryItemsTableTableManager(
    _$RepForgeDatabase db,
    $EquipmentInventoryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentInventoryItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EquipmentInventoryItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EquipmentInventoryItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentInventoryItemsCompanion(
                profileId: profileId,
                equipment: equipment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String equipment,
                Value<int> rowid = const Value.absent(),
              }) => EquipmentInventoryItemsCompanion.insert(
                profileId: profileId,
                equipment: equipment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquipmentInventoryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $EquipmentInventoryItemsTable,
      EquipmentInventoryItemRow,
      $$EquipmentInventoryItemsTableFilterComposer,
      $$EquipmentInventoryItemsTableOrderingComposer,
      $$EquipmentInventoryItemsTableAnnotationComposer,
      $$EquipmentInventoryItemsTableCreateCompanionBuilder,
      $$EquipmentInventoryItemsTableUpdateCompanionBuilder,
      (
        EquipmentInventoryItemRow,
        BaseReferences<
          _$RepForgeDatabase,
          $EquipmentInventoryItemsTable,
          EquipmentInventoryItemRow
        >,
      ),
      EquipmentInventoryItemRow,
      PrefetchHooks Function()
    >;
typedef $$OnboardingStatusesTableCreateCompanionBuilder =
    OnboardingStatusesCompanion Function({
      required String statusId,
      required String completion,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$OnboardingStatusesTableUpdateCompanionBuilder =
    OnboardingStatusesCompanion Function({
      Value<String> statusId,
      Value<String> completion,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$OnboardingStatusesTableFilterComposer
    extends Composer<_$RepForgeDatabase, $OnboardingStatusesTable> {
  $$OnboardingStatusesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get statusId => $composableBuilder(
    column: $table.statusId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OnboardingStatusesTableOrderingComposer
    extends Composer<_$RepForgeDatabase, $OnboardingStatusesTable> {
  $$OnboardingStatusesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get statusId => $composableBuilder(
    column: $table.statusId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OnboardingStatusesTableAnnotationComposer
    extends Composer<_$RepForgeDatabase, $OnboardingStatusesTable> {
  $$OnboardingStatusesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get statusId =>
      $composableBuilder(column: $table.statusId, builder: (column) => column);

  GeneratedColumn<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OnboardingStatusesTableTableManager
    extends
        RootTableManager<
          _$RepForgeDatabase,
          $OnboardingStatusesTable,
          OnboardingStatusRow,
          $$OnboardingStatusesTableFilterComposer,
          $$OnboardingStatusesTableOrderingComposer,
          $$OnboardingStatusesTableAnnotationComposer,
          $$OnboardingStatusesTableCreateCompanionBuilder,
          $$OnboardingStatusesTableUpdateCompanionBuilder,
          (
            OnboardingStatusRow,
            BaseReferences<
              _$RepForgeDatabase,
              $OnboardingStatusesTable,
              OnboardingStatusRow
            >,
          ),
          OnboardingStatusRow,
          PrefetchHooks Function()
        > {
  $$OnboardingStatusesTableTableManager(
    _$RepForgeDatabase db,
    $OnboardingStatusesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnboardingStatusesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnboardingStatusesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OnboardingStatusesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> statusId = const Value.absent(),
                Value<String> completion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnboardingStatusesCompanion(
                statusId: statusId,
                completion: completion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String statusId,
                required String completion,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => OnboardingStatusesCompanion.insert(
                statusId: statusId,
                completion: completion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OnboardingStatusesTableProcessedTableManager =
    ProcessedTableManager<
      _$RepForgeDatabase,
      $OnboardingStatusesTable,
      OnboardingStatusRow,
      $$OnboardingStatusesTableFilterComposer,
      $$OnboardingStatusesTableOrderingComposer,
      $$OnboardingStatusesTableAnnotationComposer,
      $$OnboardingStatusesTableCreateCompanionBuilder,
      $$OnboardingStatusesTableUpdateCompanionBuilder,
      (
        OnboardingStatusRow,
        BaseReferences<
          _$RepForgeDatabase,
          $OnboardingStatusesTable,
          OnboardingStatusRow
        >,
      ),
      OnboardingStatusRow,
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
  $$WorkoutGroupsTableTableManager get workoutGroups =>
      $$WorkoutGroupsTableTableManager(_db, _db.workoutGroups);
  $$WorkoutGroupExerciseAssignmentsTableTableManager
  get workoutGroupExerciseAssignments =>
      $$WorkoutGroupExerciseAssignmentsTableTableManager(
        _db,
        _db.workoutGroupExerciseAssignments,
      );
  $$SettingsProfilesTableTableManager get settingsProfiles =>
      $$SettingsProfilesTableTableManager(_db, _db.settingsProfiles);
  $$EquipmentInventoryItemsTableTableManager get equipmentInventoryItems =>
      $$EquipmentInventoryItemsTableTableManager(
        _db,
        _db.equipmentInventoryItems,
      );
  $$OnboardingStatusesTableTableManager get onboardingStatuses =>
      $$OnboardingStatusesTableTableManager(_db, _db.onboardingStatuses);
}
