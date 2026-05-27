import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/training_log/data/mappers/workout_set_mapper.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  group('WorkoutSetMapper', () {
    test(
      'round-trips an official exercise reference with catalog snapshot',
      () {
        final set = WorkoutSet(
          id: WorkoutSetId('set-1'),
          exerciseRef: ExerciseRef.official(
            id: OfficialExerciseId('barbell-bench-press'),
            displayNameSnapshot: 'Barbell Bench Press',
            catalogVersionSnapshot: '2026.05.0',
          ),
          workoutSessionId: WorkoutSessionId('session-1'),
          repetitions: Repetitions(5),
          load: LoadKg(100),
          performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 10, 30)),
          comment: SetComment('Top set'),
        );

        final companion = WorkoutSetMapper.toCompanion(set);
        final row = _rowFromCompanion(companion);

        expect(row.workoutSetId, 'set-1');
        expect(row.exerciseSource, 'official');
        expect(row.exerciseId, 'barbell-bench-press');
        expect(row.exerciseDisplayNameSnapshot, 'Barbell Bench Press');
        expect(row.catalogVersionSnapshot, '2026.05.0');
        expect(row.workoutSessionId, 'session-1');
        expect(row.comment, 'Top set');
        expect(WorkoutSetMapper.toDomain(row), set);
      },
    );

    test('round-trips a custom exercise reference without catalog data', () {
      final set = WorkoutSet(
        id: WorkoutSetId('set-custom-1'),
        exerciseRef: ExerciseRef.custom(
          id: CustomExerciseId('custom-row-1'),
          displayNameSnapshot: 'Cable Row Variant',
        ),
        repetitions: Repetitions(8),
        load: LoadKg(42.5),
        performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 11)),
      );

      final row = _rowFromCompanion(WorkoutSetMapper.toCompanion(set));

      expect(row.exerciseSource, 'custom');
      expect(row.exerciseId, 'custom-row-1');
      expect(row.exerciseDisplayNameSnapshot, 'Cable Row Variant');
      expect(row.catalogVersionSnapshot, isNull);
      expect(row.workoutSessionId, isNull);
      expect(row.comment, isNull);
      expect(WorkoutSetMapper.toDomain(row), set);
    });

    test('preserves optional session and comment when present or absent', () {
      final withOptionals = _officialSet(
        id: 'set-with-optionals',
        workoutSessionId: WorkoutSessionId('session-1'),
        comment: SetComment('Smooth reps'),
      );
      final withoutOptionals = _officialSet(id: 'set-without-optionals');

      expect(
        WorkoutSetMapper.toDomain(
          _rowFromCompanion(WorkoutSetMapper.toCompanion(withOptionals)),
        ),
        withOptionals,
      );
      expect(
        WorkoutSetMapper.toDomain(
          _rowFromCompanion(WorkoutSetMapper.toCompanion(withoutOptionals)),
        ),
        withoutOptionals,
      );
    });

    test('rejects custom persisted rows with catalog version snapshots', () {
      final row = _row(exerciseSource: 'custom');

      expect(
        () => WorkoutSetMapper.toDomain(row),
        throwsA(
          isA<TrainingLogValidationException>()
              .having(
                (TrainingLogValidationException error) => error.field,
                'field',
                'exerciseRef.catalogVersionSnapshot',
              )
              .having(
                (TrainingLogValidationException error) => error.message,
                'message',
                contains('Custom exercise rows must not'),
              ),
        ),
      );
    });

    test('rejects unsupported persisted exercise source values', () {
      final row = _row(exerciseSource: 'remote');

      expect(
        () => WorkoutSetMapper.toDomain(row),
        throwsA(
          isA<TrainingLogValidationException>().having(
            (TrainingLogValidationException error) => error.field,
            'field',
            'exerciseRef.source',
          ),
        ),
      );
    });
  });
}

WorkoutSet _officialSet({
  required String id,
  WorkoutSessionId? workoutSessionId,
  SetComment? comment,
}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('deadlift'),
      displayNameSnapshot: 'Deadlift',
      catalogVersionSnapshot: '2026.05.0',
    ),
    workoutSessionId: workoutSessionId,
    repetitions: Repetitions(3),
    load: LoadKg(140),
    performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 12)),
    comment: comment,
  );
}

WorkoutSetRow _row({
  String exerciseSource = 'official',
  String? catalogVersionSnapshot = '2026.05.0',
}) {
  return WorkoutSetRow(
    workoutSetId: 'set-row',
    exerciseSource: exerciseSource,
    exerciseId: 'exercise-1',
    exerciseDisplayNameSnapshot: 'Exercise 1',
    catalogVersionSnapshot: catalogVersionSnapshot,
    repetitions: 5,
    loadKg: 100,
    performedAt: DateTime.utc(2026, 5, 27, 12),
  );
}

WorkoutSetRow _rowFromCompanion(WorkoutSetsCompanion companion) {
  return WorkoutSetRow(
    workoutSetId: companion.workoutSetId.value,
    exerciseSource: companion.exerciseSource.value,
    exerciseId: companion.exerciseId.value,
    exerciseDisplayNameSnapshot: companion.exerciseDisplayNameSnapshot.value,
    catalogVersionSnapshot: companion.catalogVersionSnapshot.value,
    workoutSessionId: companion.workoutSessionId.value,
    repetitions: companion.repetitions.value,
    loadKg: companion.loadKg.value,
    performedAt: companion.performedAt.value,
    comment: companion.comment.value,
  );
}
