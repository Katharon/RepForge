import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/training_log/data/repositories/drift_workout_set_repository.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;
  late DriftWorkoutSetRepository repository;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
    repository = DriftWorkoutSetRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('saves and finds a workout set by stable id', () async {
    final set = _set(id: 'set-1');

    await repository.save(set);

    expect(await repository.findById(WorkoutSetId('set-1')), set);
  });

  test('returns null for a missing workout set id', () async {
    expect(await repository.findById(WorkoutSetId('missing')), isNull);
  });

  test(
    'historyForExercise filters by stable source and id while preserving snapshots',
    () async {
      await repository.save(
        _set(
          id: 'set-old-name',
          exerciseDisplayNameSnapshot: 'Old Bench Name',
          performedAt: DateTime.utc(2026, 5, 27, 9),
        ),
      );
      await repository.save(
        _set(
          id: 'set-new-name',
          exerciseDisplayNameSnapshot: 'New Bench Name',
          performedAt: DateTime.utc(2026, 5, 27, 10),
        ),
      );
      await repository.save(
        _set(
          id: 'set-other-exercise',
          exerciseId: 'deadlift',
          exerciseDisplayNameSnapshot: 'Deadlift',
        ),
      );

      final history = await repository.historyForExercise(
        ExerciseRef.official(
          id: OfficialExerciseId('barbell-bench-press'),
          displayNameSnapshot: 'Current Bench Name',
          catalogVersionSnapshot: '2026.06.0',
        ),
      );

      expect(history.map((WorkoutSet set) => set.id.value), <String>[
        'set-old-name',
        'set-new-name',
      ]);
      expect(
        history.map((WorkoutSet set) => set.exerciseRef.displayNameSnapshot),
        <String>['Old Bench Name', 'New Bench Name'],
      );
    },
  );

  test('setsForWorkoutSession filters by stable session id', () async {
    await repository.save(
      _set(id: 'set-session-1', workoutSessionId: 'session-1'),
    );
    await repository.save(
      _set(id: 'set-session-2', workoutSessionId: 'session-2'),
    );
    await repository.save(_set(id: 'set-without-session'));

    final sets = await repository.setsForWorkoutSession(
      WorkoutSessionId('session-1'),
    );

    expect(sets.map((WorkoutSet set) => set.id.value), <String>[
      'set-session-1',
    ]);
  });

  test(
    'list methods order by performedAt then workoutSetId ascending',
    () async {
      await repository.save(
        _set(
          id: 'set-c',
          workoutSessionId: 'session-1',
          performedAt: DateTime.utc(2026, 5, 27, 10),
        ),
      );
      await repository.save(
        _set(
          id: 'set-a',
          workoutSessionId: 'session-1',
          performedAt: DateTime.utc(2026, 5, 27, 9),
        ),
      );
      await repository.save(
        _set(
          id: 'set-b',
          workoutSessionId: 'session-1',
          performedAt: DateTime.utc(2026, 5, 27, 10),
        ),
      );

      final sessionSets = await repository.setsForWorkoutSession(
        WorkoutSessionId('session-1'),
      );
      final exerciseHistory = await repository.historyForExercise(
        ExerciseRef.official(
          id: OfficialExerciseId('barbell-bench-press'),
          displayNameSnapshot: 'Bench',
        ),
      );

      expect(sessionSets.map((WorkoutSet set) => set.id.value), <String>[
        'set-a',
        'set-b',
        'set-c',
      ]);
      expect(exerciseHistory.map((WorkoutSet set) => set.id.value), <String>[
        'set-a',
        'set-b',
        'set-c',
      ]);
    },
  );

  test(
    'save upserts by workoutSetId and clears stale nullable values',
    () async {
      await repository.save(
        _set(
          id: 'set-upsert',
          workoutSessionId: 'session-1',
          comment: 'Top set',
        ),
      );
      await repository.save(_set(id: 'set-upsert', repetitions: 8, loadKg: 90));

      final found = await repository.findById(WorkoutSetId('set-upsert'));
      final row = await database.select(database.workoutSets).getSingle();

      expect(found?.repetitions, Repetitions(8));
      expect(found?.load, LoadKg(90));
      expect(found?.workoutSessionId, isNull);
      expect(found?.comment, isNull);
      expect(row.workoutSessionId, isNull);
      expect(row.comment, isNull);
    },
  );

  test(
    'save clears catalogVersionSnapshot when an upsert changes to custom',
    () async {
      await repository.save(_set(id: 'set-source-change'));
      await repository.save(
        _set(
          id: 'set-source-change',
          exerciseRef: ExerciseRef.custom(
            id: CustomExerciseId('custom-row'),
            displayNameSnapshot: 'Custom Row',
          ),
        ),
      );

      final found = await repository.findById(
        WorkoutSetId('set-source-change'),
      );
      final row = await database.select(database.workoutSets).getSingle();

      expect(found?.exerciseRef.source, ExerciseSource.custom);
      expect(found?.exerciseRef.catalogVersionSnapshot, isNull);
      expect(row.catalogVersionSnapshot, isNull);
    },
  );
}

WorkoutSet _set({
  required String id,
  String exerciseId = 'barbell-bench-press',
  String exerciseDisplayNameSnapshot = 'Barbell Bench Press',
  ExerciseRef? exerciseRef,
  String? workoutSessionId,
  int repetitions = 5,
  num loadKg = 100,
  DateTime? performedAt,
  String? comment,
}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef:
        exerciseRef ??
        ExerciseRef.official(
          id: OfficialExerciseId(exerciseId),
          displayNameSnapshot: exerciseDisplayNameSnapshot,
          catalogVersionSnapshot: '2026.05.0',
        ),
    workoutSessionId: workoutSessionId == null
        ? null
        : WorkoutSessionId(workoutSessionId),
    repetitions: Repetitions(repetitions),
    load: LoadKg(loadKg),
    performedAt: PerformedAt(performedAt ?? DateTime.utc(2026, 5, 27, 12)),
    comment: comment == null ? null : SetComment(comment),
  );
}
