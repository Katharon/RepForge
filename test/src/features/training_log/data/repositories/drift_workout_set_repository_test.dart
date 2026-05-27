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

  test('timelineForExercise returns newest-first first page', () async {
    await repository.save(
      _set(id: 'set-1', performedAt: DateTime.utc(2026, 5, 27, 9)),
    );
    await repository.save(
      _set(id: 'set-3', performedAt: DateTime.utc(2026, 5, 27, 11)),
    );
    await repository.save(
      _set(id: 'set-2', performedAt: DateTime.utc(2026, 5, 27, 10)),
    );

    final page = await repository.timelineForExercise(
      WorkoutSetTimelineQuery(
        exerciseRef: ExerciseRef.official(
          id: OfficialExerciseId('barbell-bench-press'),
          displayNameSnapshot: 'Bench',
        ),
        limit: 2,
      ),
    );

    expect(page.items.map((WorkoutSet set) => set.id.value), <String>[
      'set-3',
      'set-2',
    ]);
    expect(page.hasMore, isTrue);
    expect(page.nextCursor, WorkoutSetTimelineCursor.fromSet(page.items.last));
  });

  test('timelineForExercise returns next page using cursor', () async {
    await repository.save(
      _set(id: 'set-1', performedAt: DateTime.utc(2026, 5, 27, 9)),
    );
    await repository.save(
      _set(id: 'set-2', performedAt: DateTime.utc(2026, 5, 27, 10)),
    );
    await repository.save(
      _set(id: 'set-3', performedAt: DateTime.utc(2026, 5, 27, 11)),
    );
    await repository.save(
      _set(id: 'set-4', performedAt: DateTime.utc(2026, 5, 27, 12)),
    );

    final firstPage = await repository.timelineForExercise(
      WorkoutSetTimelineQuery(
        exerciseRef: ExerciseRef.official(
          id: OfficialExerciseId('barbell-bench-press'),
          displayNameSnapshot: 'Bench',
        ),
        limit: 2,
      ),
    );
    final secondPage = await repository.timelineForExercise(
      WorkoutSetTimelineQuery(
        exerciseRef: ExerciseRef.official(
          id: OfficialExerciseId('barbell-bench-press'),
          displayNameSnapshot: 'Bench',
        ),
        limit: 2,
        after: firstPage.nextCursor,
      ),
    );

    expect(firstPage.items.map((WorkoutSet set) => set.id.value), <String>[
      'set-4',
      'set-3',
    ]);
    expect(secondPage.items.map((WorkoutSet set) => set.id.value), <String>[
      'set-2',
      'set-1',
    ]);
    expect(secondPage.hasMore, isFalse);
    expect(secondPage.nextCursor, isNull);
  });

  test('timelineForExercise uses workoutSetId tie-breaker', () async {
    final sameTimestamp = DateTime.utc(2026, 5, 27, 10);
    await repository.save(_set(id: 'set-a', performedAt: sameTimestamp));
    await repository.save(_set(id: 'set-c', performedAt: sameTimestamp));
    await repository.save(_set(id: 'set-b', performedAt: sameTimestamp));

    final firstPage = await repository.timelineForExercise(
      WorkoutSetTimelineQuery(
        exerciseRef: ExerciseRef.official(
          id: OfficialExerciseId('barbell-bench-press'),
          displayNameSnapshot: 'Bench',
        ),
        limit: 2,
      ),
    );
    final secondPage = await repository.timelineForExercise(
      WorkoutSetTimelineQuery(
        exerciseRef: ExerciseRef.official(
          id: OfficialExerciseId('barbell-bench-press'),
          displayNameSnapshot: 'Bench',
        ),
        limit: 2,
        after: firstPage.nextCursor,
      ),
    );

    expect(firstPage.items.map((WorkoutSet set) => set.id.value), <String>[
      'set-c',
      'set-b',
    ]);
    expect(secondPage.items.map((WorkoutSet set) => set.id.value), <String>[
      'set-a',
    ]);
  });

  test(
    'timelineForExercise filters by stable source and id while preserving snapshots',
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
          performedAt: DateTime.utc(2026, 5, 27, 11),
        ),
      );

      final page = await repository.timelineForExercise(
        WorkoutSetTimelineQuery(
          exerciseRef: ExerciseRef.official(
            id: OfficialExerciseId('barbell-bench-press'),
            displayNameSnapshot: 'Current Bench Name',
            catalogVersionSnapshot: '2026.06.0',
          ),
          limit: 10,
        ),
      );

      expect(page.items.map((WorkoutSet set) => set.id.value), <String>[
        'set-new-name',
        'set-old-name',
      ]);
      expect(
        page.items.map((WorkoutSet set) => set.exerciseRef.displayNameSnapshot),
        <String>['New Bench Name', 'Old Bench Name'],
      );
      expect(
        page.items.map(
          (WorkoutSet set) => set.exerciseRef.catalogVersionSnapshot,
        ),
        <String?>['2026.05.0', '2026.05.0'],
      );
    },
  );

  test('timelineForExercise supports custom exercise references', () async {
    final customRef = ExerciseRef.custom(
      id: CustomExerciseId('custom-row'),
      displayNameSnapshot: 'Custom Row',
    );
    await repository.save(_set(id: 'custom-1', exerciseRef: customRef));
    await repository.save(_set(id: 'official-1'));

    final page = await repository.timelineForExercise(
      WorkoutSetTimelineQuery(exerciseRef: customRef, limit: 10),
    );

    expect(page.items.map((WorkoutSet set) => set.id.value), <String>[
      'custom-1',
    ]);
    expect(page.items.single.exerciseRef, customRef);
  });

  test('timelineForExercise returns empty page for missing exercise', () async {
    final page = await repository.timelineForExercise(
      WorkoutSetTimelineQuery(
        exerciseRef: ExerciseRef.official(
          id: OfficialExerciseId('missing-exercise'),
          displayNameSnapshot: 'Missing',
        ),
        limit: 10,
      ),
    );

    expect(page.items, isEmpty);
    expect(page.hasMore, isFalse);
    expect(page.nextCursor, isNull);
  });

  test('timelineForExercise rejects invalid limit', () {
    expect(
      () => WorkoutSetTimelineQuery(
        exerciseRef: ExerciseRef.official(
          id: OfficialExerciseId('barbell-bench-press'),
          displayNameSnapshot: 'Bench',
        ),
        limit: 0,
      ),
      throwsA(isA<TrainingLogValidationException>()),
    );
  });

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

  test('deleteById removes only the target set', () async {
    await repository.save(_set(id: 'set-delete'));
    await repository.save(_set(id: 'set-keep'));

    await repository.deleteById(WorkoutSetId('set-delete'));

    expect(await repository.findById(WorkoutSetId('set-delete')), isNull);
    expect(await repository.findById(WorkoutSetId('set-keep')), isNotNull);
  });

  test('timeline and history no longer return deleted sets', () async {
    await repository.save(
      _set(id: 'set-delete', performedAt: DateTime.utc(2026, 5, 27, 11)),
    );
    await repository.save(
      _set(id: 'set-keep', performedAt: DateTime.utc(2026, 5, 27, 10)),
    );

    await repository.deleteById(WorkoutSetId('set-delete'));

    final exerciseRef = ExerciseRef.official(
      id: OfficialExerciseId('barbell-bench-press'),
      displayNameSnapshot: 'Bench',
    );
    final history = await repository.historyForExercise(exerciseRef);
    final timeline = await repository.timelineForExercise(
      WorkoutSetTimelineQuery(exerciseRef: exerciseRef, limit: 10),
    );

    expect(history.map((WorkoutSet set) => set.id.value), <String>['set-keep']);
    expect(timeline.items.map((WorkoutSet set) => set.id.value), <String>[
      'set-keep',
    ]);
  });
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
