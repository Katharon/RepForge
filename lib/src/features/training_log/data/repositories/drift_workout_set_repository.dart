import 'package:drift/drift.dart';
import 'package:repforge/src/features/training_log/data/mappers/workout_set_mapper.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

final class DriftWorkoutSetRepository implements WorkoutSetRepository {
  const DriftWorkoutSetRepository(this._database);

  final RepForgeDatabase _database;

  @override
  Future<void> save(WorkoutSet set) async {
    await _database
        .into(_database.workoutSets)
        .insertOnConflictUpdate(WorkoutSetMapper.toCompanion(set));
  }

  @override
  Future<void> deleteById(WorkoutSetId id) async {
    await (_database.delete(_database.workoutSets)
          ..where(($WorkoutSetsTable table) {
            return table.workoutSetId.equals(id.value);
          }))
        .go();
  }

  @override
  Future<WorkoutSet?> findById(WorkoutSetId id) async {
    final rows =
        await (_database.select(_database.workoutSets)
              ..where(($WorkoutSetsTable table) {
                return table.workoutSetId.equals(id.value);
              }))
            .get();

    if (rows.isEmpty) {
      return null;
    }

    return WorkoutSetMapper.toDomain(rows.single);
  }

  @override
  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef) async {
    final source = WorkoutSetMapper.toStorageExerciseSource(exerciseRef);
    final rows =
        await (_database.select(_database.workoutSets)
              ..where(($WorkoutSetsTable table) {
                return table.exerciseSource.equals(source) &
                    table.exerciseId.equals(exerciseRef.id);
              })
              ..orderBy(_chronologicalOrder))
            .get();

    return rows.map(WorkoutSetMapper.toDomain).toList(growable: false);
  }

  @override
  Future<WorkoutSetHistoryPage> searchHistory(
    WorkoutSetHistoryQuery query,
  ) async {
    final filter = _WorkoutSetHistorySqlFilter.fromQuery(query);
    final totalCount = await _countMatchingHistory(filter);
    final rows = await _queryMatchingHistoryRows(filter, query);

    return WorkoutSetHistoryPage(
      items: rows.map(WorkoutSetMapper.toDomain),
      totalCount: totalCount,
      limit: query.limit,
      offset: query.offset,
    );
  }

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) async {
    final source = WorkoutSetMapper.toStorageExerciseSource(query.exerciseRef);
    final cursor = query.after;
    final rows =
        await (_database.select(_database.workoutSets)
              ..where(($WorkoutSetsTable table) {
                final exerciseFilter =
                    table.exerciseSource.equals(source) &
                    table.exerciseId.equals(query.exerciseRef.id);

                if (cursor == null) {
                  return exerciseFilter;
                }

                return exerciseFilter &
                    (table.performedAt.isSmallerThanValue(cursor.performedAt) |
                        (table.performedAt.equals(cursor.performedAt) &
                            table.workoutSetId.isSmallerThanValue(
                              cursor.workoutSetId.value,
                            )));
              })
              ..orderBy(_timelineOrder)
              ..limit(query.limit + 1))
            .get();
    final hasMore = rows.length > query.limit;
    final pageRows = hasMore ? rows.take(query.limit) : rows;
    final sets = pageRows
        .map(WorkoutSetMapper.toDomain)
        .toList(growable: false);
    final nextCursor = hasMore && sets.isNotEmpty
        ? WorkoutSetTimelineCursor.fromSet(sets.last)
        : null;

    return WorkoutSetTimelinePage(
      items: sets,
      hasMore: hasMore,
      nextCursor: nextCursor,
    );
  }

  @override
  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  ) async {
    final rows =
        await (_database.select(_database.workoutSets)
              ..where(($WorkoutSetsTable table) {
                return table.workoutSessionId.equals(workoutSessionId.value);
              })
              ..orderBy(_chronologicalOrder))
            .get();

    return rows.map(WorkoutSetMapper.toDomain).toList(growable: false);
  }

  Future<int> _countMatchingHistory(_WorkoutSetHistorySqlFilter filter) async {
    final row = await _database
        .customSelect(
          '''
SELECT COUNT(*) AS total_count
FROM workout_sets ws
${filter.whereSql}
''',
          variables: filter.variables,
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.workoutSets,
          },
        )
        .getSingle();

    return row.read<int>('total_count');
  }

  Future<List<WorkoutSetRow>> _queryMatchingHistoryRows(
    _WorkoutSetHistorySqlFilter filter,
    WorkoutSetHistoryQuery query,
  ) async {
    final rows = await _database
        .customSelect(
          '''
SELECT
  ws.workout_set_id,
  ws.exercise_source,
  ws.exercise_id,
  ws.exercise_display_name_snapshot,
  ws.catalog_version_snapshot,
  ws.workout_session_id,
  ws.repetitions,
  ws.load_kg,
  ws.performed_at,
  ws.comment,
  ws.set_label
FROM workout_sets ws
${filter.whereSql}
ORDER BY ${_historyOrderSql(query.sort)}
LIMIT ? OFFSET ?
''',
          variables: <Variable<Object>>[
            ...filter.variables,
            Variable<int>(query.limit),
            Variable<int>(query.offset),
          ],
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.workoutSets,
          },
        )
        .get();

    return rows.map(_workoutSetRowFromQuery).toList(growable: false);
  }

  WorkoutSetRow _workoutSetRowFromQuery(QueryRow row) {
    return WorkoutSetRow(
      workoutSetId: row.read<String>('workout_set_id'),
      exerciseSource: row.read<String>('exercise_source'),
      exerciseId: row.read<String>('exercise_id'),
      exerciseDisplayNameSnapshot: row.read<String>(
        'exercise_display_name_snapshot',
      ),
      catalogVersionSnapshot: row.readNullable<String>(
        'catalog_version_snapshot',
      ),
      workoutSessionId: row.readNullable<String>('workout_session_id'),
      repetitions: row.read<int>('repetitions'),
      loadKg: row.read<double>('load_kg'),
      performedAt: DateTime.fromMillisecondsSinceEpoch(
        row.read<int>('performed_at'),
        isUtc: true,
      ),
      comment: row.readNullable<String>('comment'),
      setLabel: row.readNullable<String>('set_label'),
    );
  }
}

final List<OrderingTerm Function($WorkoutSetsTable)> _chronologicalOrder =
    <OrderingTerm Function($WorkoutSetsTable)>[
      ($WorkoutSetsTable table) => OrderingTerm.asc(table.performedAt),
      ($WorkoutSetsTable table) => OrderingTerm.asc(table.workoutSetId),
    ];

final List<OrderingTerm Function($WorkoutSetsTable)> _timelineOrder =
    <OrderingTerm Function($WorkoutSetsTable)>[
      ($WorkoutSetsTable table) => OrderingTerm.desc(table.performedAt),
      ($WorkoutSetsTable table) => OrderingTerm.desc(table.workoutSetId),
    ];

String _historyOrderSql(WorkoutSetHistorySort sort) {
  return switch (sort) {
    WorkoutSetHistorySort.newestFirst =>
      'ws.performed_at DESC, ws.workout_set_id DESC',
    WorkoutSetHistorySort.oldestFirst =>
      'ws.performed_at ASC, ws.workout_set_id ASC',
  };
}

final class _WorkoutSetHistorySqlFilter {
  const _WorkoutSetHistorySqlFilter({
    required this.whereSql,
    required this.variables,
  });

  factory _WorkoutSetHistorySqlFilter.fromQuery(WorkoutSetHistoryQuery query) {
    final clauses = <String>[];
    final variables = <Variable<Object>>[];
    final searchText = query.searchText;

    if (searchText != null) {
      final pattern = '%${searchText.toLowerCase()}%';
      clauses.add(
        '('
        'lower(ws.workout_set_id) LIKE ? OR '
        'lower(ws.exercise_id) LIKE ? OR '
        'lower(ws.exercise_display_name_snapshot) LIKE ? OR '
        'lower(COALESCE(ws.workout_session_id, \'\')) LIKE ? OR '
        'lower(COALESCE(ws.comment, \'\')) LIKE ?'
        ')',
      );
      variables
        ..add(Variable<String>(pattern))
        ..add(Variable<String>(pattern))
        ..add(Variable<String>(pattern))
        ..add(Variable<String>(pattern))
        ..add(Variable<String>(pattern));
    }

    if (query.labels.isNotEmpty) {
      final labelClauses = <String>[];
      for (final label in query.labels) {
        if (label == WorkoutSetLabel.none) {
          labelClauses.add(
            '(ws.set_label IS NULL OR ws.set_label = \'\' OR ws.set_label = ?)',
          );
        } else {
          labelClauses.add('ws.set_label = ?');
        }
        variables.add(Variable<String>(label.storageValue));
      }
      clauses.add('(${labelClauses.join(' OR ')})');
    }

    return _WorkoutSetHistorySqlFilter(
      whereSql: clauses.isEmpty ? '' : 'WHERE ${clauses.join(' AND ')}',
      variables: List<Variable<Object>>.unmodifiable(variables),
    );
  }

  final String whereSql;
  final List<Variable<Object>> variables;
}
