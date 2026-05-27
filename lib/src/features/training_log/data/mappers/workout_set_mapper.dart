import 'package:drift/drift.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

final class WorkoutSetMapper {
  const WorkoutSetMapper._();

  static const String officialSource = 'official';
  static const String customSource = 'custom';

  static WorkoutSetsCompanion toCompanion(WorkoutSet set) {
    return WorkoutSetsCompanion(
      workoutSetId: Value<String>(set.id.value),
      exerciseSource: Value<String>(toStorageExerciseSource(set.exerciseRef)),
      exerciseId: Value<String>(set.exerciseRef.id),
      exerciseDisplayNameSnapshot: Value<String>(
        set.exerciseRef.displayNameSnapshot,
      ),
      catalogVersionSnapshot: Value<String?>(
        set.exerciseRef.catalogVersionSnapshot,
      ),
      workoutSessionId: Value<String?>(set.workoutSessionId?.value),
      repetitions: Value<int>(set.repetitions.value),
      loadKg: Value<double>(set.load.value),
      performedAt: Value<DateTime>(set.performedAt.value.toUtc()),
      comment: Value<String?>(set.comment?.value),
    );
  }

  static WorkoutSet toDomain(WorkoutSetRow row) {
    final exerciseRef = switch (row.exerciseSource) {
      officialSource => ExerciseRef.official(
        id: OfficialExerciseId(row.exerciseId),
        displayNameSnapshot: row.exerciseDisplayNameSnapshot,
        catalogVersionSnapshot: row.catalogVersionSnapshot,
      ),
      customSource => _customExerciseRef(row),
      _ => throw TrainingLogValidationException(
        'exerciseRef.source',
        'Unsupported persisted exercise source: ${row.exerciseSource}.',
      ),
    };

    return WorkoutSet(
      id: WorkoutSetId(row.workoutSetId),
      exerciseRef: exerciseRef,
      workoutSessionId: row.workoutSessionId == null
          ? null
          : WorkoutSessionId(row.workoutSessionId!),
      repetitions: Repetitions(row.repetitions),
      load: LoadKg(row.loadKg),
      performedAt: PerformedAt(row.performedAt.toUtc()),
      comment: row.comment == null ? null : SetComment(row.comment!),
    );
  }

  static String toStorageExerciseSource(ExerciseRef exerciseRef) {
    return switch (exerciseRef.source) {
      ExerciseSource.official => officialSource,
      ExerciseSource.custom => customSource,
    };
  }

  static ExerciseRef _customExerciseRef(WorkoutSetRow row) {
    if (row.catalogVersionSnapshot != null) {
      throw const TrainingLogValidationException(
        'exerciseRef.catalogVersionSnapshot',
        'Custom exercise rows must not contain catalog version snapshots.',
      );
    }

    return ExerciseRef.custom(
      id: CustomExerciseId(row.exerciseId),
      displayNameSnapshot: row.exerciseDisplayNameSnapshot,
    );
  }
}
