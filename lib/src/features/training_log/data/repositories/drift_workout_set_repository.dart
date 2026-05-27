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
}

final List<OrderingTerm Function($WorkoutSetsTable)> _chronologicalOrder =
    <OrderingTerm Function($WorkoutSetsTable)>[
      ($WorkoutSetsTable table) => OrderingTerm.asc(table.performedAt),
      ($WorkoutSetsTable table) => OrderingTerm.asc(table.workoutSetId),
    ];
