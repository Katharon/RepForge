import 'package:drift/drift.dart' hide isNotNull, isNull;
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
    final set = _set(id: 'set-1', label: WorkoutSetLabel.personalRecord);

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

  test('timelineForExercise returns labels with workout sets', () async {
    await repository.save(
      _set(
        id: 'set-warmup',
        performedAt: DateTime.utc(2026, 5, 27, 9),
        label: WorkoutSetLabel.warmup,
      ),
    );
    await repository.save(
      _set(
        id: 'set-failure',
        performedAt: DateTime.utc(2026, 5, 27, 10),
        label: WorkoutSetLabel.failure,
      ),
    );

    final exerciseRef = ExerciseRef.official(
      id: OfficialExerciseId('barbell-bench-press'),
      displayNameSnapshot: 'Bench',
    );
    final history = await repository.historyForExercise(exerciseRef);
    final timeline = await repository.timelineForExercise(
      WorkoutSetTimelineQuery(exerciseRef: exerciseRef, limit: 10),
    );

    expect(history.map((WorkoutSet set) => set.label), <WorkoutSetLabel>[
      WorkoutSetLabel.warmup,
      WorkoutSetLabel.failure,
    ]);
    expect(timeline.items.map((WorkoutSet set) => set.label), <WorkoutSetLabel>[
      WorkoutSetLabel.failure,
      WorkoutSetLabel.warmup,
    ]);
  });

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

  test('save round-trips label and stores the stable label value', () async {
    await repository.save(
      _set(id: 'set-label', label: WorkoutSetLabel.dropSet),
    );

    final found = await repository.findById(WorkoutSetId('set-label'));
    final row = await database.select(database.workoutSets).getSingle();

    expect(found?.label, WorkoutSetLabel.dropSet);
    expect(row.setLabel, 'dropSet');
  });

  test(
    'save can update label without changing id or ExerciseRef snapshot',
    () async {
      final exerciseRef = ExerciseRef.official(
        id: OfficialExerciseId('barbell-bench-press'),
        displayNameSnapshot: 'Old Bench Snapshot',
        catalogVersionSnapshot: '2026.05.0',
      );
      await repository.save(
        _set(
          id: 'set-label-update',
          exerciseRef: exerciseRef,
          label: WorkoutSetLabel.warmup,
        ),
      );

      await repository.save(
        _set(
          id: 'set-label-update',
          exerciseRef: exerciseRef,
          label: WorkoutSetLabel.failure,
        ),
      );

      final found = await repository.findById(WorkoutSetId('set-label-update'));

      expect(found?.id, WorkoutSetId('set-label-update'));
      expect(found?.exerciseRef, exerciseRef);
      expect(found?.label, WorkoutSetLabel.failure);
    },
  );

  test('legacy null label maps to none', () async {
    await database
        .into(database.workoutSets)
        .insert(
          WorkoutSetsCompanion.insert(
            workoutSetId: 'set-legacy-label',
            exerciseSource: 'official',
            exerciseId: 'barbell-bench-press',
            exerciseDisplayNameSnapshot: 'Barbell Bench Press',
            catalogVersionSnapshot: const Value<String?>('2026.05.0'),
            repetitions: 5,
            loadKg: 100,
            performedAt: DateTime.utc(2026, 5, 27, 12),
          ),
        );

    final found = await repository.findById(WorkoutSetId('set-legacy-label'));

    expect(found?.label, WorkoutSetLabel.none);
  });

  test('legacy empty label maps to none', () async {
    await database
        .into(database.workoutSets)
        .insert(
          WorkoutSetsCompanion.insert(
            workoutSetId: 'set-empty-label',
            exerciseSource: 'official',
            exerciseId: 'barbell-bench-press',
            exerciseDisplayNameSnapshot: 'Barbell Bench Press',
            catalogVersionSnapshot: const Value<String?>('2026.05.0'),
            repetitions: 5,
            loadKg: 100,
            performedAt: DateTime.utc(2026, 5, 27, 12),
            setLabel: const Value<String?>(''),
          ),
        );

    final found = await repository.findById(WorkoutSetId('set-empty-label'));

    expect(found?.label, WorkoutSetLabel.none);
  });

  test(
    'invalid stored label throws deterministic validation exception',
    () async {
      await database.customStatement('PRAGMA ignore_check_constraints = ON');
      await database.customInsert(
        '''
      INSERT INTO workout_sets (
        workout_set_id,
        exercise_source,
        exercise_id,
        exercise_display_name_snapshot,
        catalog_version_snapshot,
        repetitions,
        load_kg,
        performed_at,
        set_label
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
        variables: <Variable<Object>>[
          const Variable<String>('set-invalid-label'),
          const Variable<String>('official'),
          const Variable<String>('barbell-bench-press'),
          const Variable<String>('Barbell Bench Press'),
          const Variable<String>('2026.05.0'),
          const Variable<int>(5),
          const Variable<double>(100),
          Variable<DateTime>(DateTime.utc(2026, 5, 27, 12)),
          const Variable<String>('tempo'),
        ],
      );
      await database.customStatement('PRAGMA ignore_check_constraints = OFF');

      await expectLater(
        repository.findById(WorkoutSetId('set-invalid-label')),
        throwsA(
          isA<TrainingLogValidationException>().having(
            (TrainingLogValidationException error) => error.field,
            'field',
            'setLabel',
          ),
        ),
      );
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

  test('searchHistory filters by search text and label', () async {
    await repository.save(
      _set(
        id: 'set-bench-pr',
        comment: 'Top set',
        label: WorkoutSetLabel.personalRecord,
      ),
    );
    await repository.save(
      _set(
        id: 'set-bench-warmup',
        comment: 'Warmup',
        label: WorkoutSetLabel.warmup,
      ),
    );
    await repository.save(
      _set(
        id: 'set-squat-pr',
        exerciseId: 'barbell-back-squat',
        exerciseDisplayNameSnapshot: 'Barbell Back Squat',
        label: WorkoutSetLabel.personalRecord,
      ),
    );

    final page = await repository.searchHistory(
      WorkoutSetHistoryQuery(
        limit: 10,
        offset: 0,
        searchText: 'bench',
        labels: <WorkoutSetLabel>[WorkoutSetLabel.personalRecord],
      ),
    );

    expect(page.totalCount, 1);
    expect(page.hasMore, isFalse);
    expect(page.items.single.id.value, 'set-bench-pr');
  });

  test(
    'searchHistory sorts deterministically and keeps offset pagination bounded',
    () async {
      final sameTimestamp = DateTime.utc(2026, 5, 27, 10);
      await repository.save(_set(id: 'set-a', performedAt: sameTimestamp));
      await repository.save(_set(id: 'set-c', performedAt: sameTimestamp));
      await repository.save(
        _set(id: 'set-b', performedAt: DateTime.utc(2026, 5, 27, 9)),
      );

      final firstPage = await repository.searchHistory(
        WorkoutSetHistoryQuery(limit: 2, offset: 0),
      );
      final secondPage = await repository.searchHistory(
        WorkoutSetHistoryQuery(limit: 2, offset: 2),
      );
      final oldestFirst = await repository.searchHistory(
        WorkoutSetHistoryQuery(
          limit: 10,
          offset: 0,
          sort: WorkoutSetHistorySort.oldestFirst,
        ),
      );

      expect(firstPage.totalCount, 3);
      expect(firstPage.hasMore, isTrue);
      expect(firstPage.items.map((set) => set.id.value), <String>[
        'set-c',
        'set-a',
      ]);
      expect(secondPage.items.map((set) => set.id.value), <String>['set-b']);
      expect(oldestFirst.items.map((set) => set.id.value), <String>[
        'set-b',
        'set-a',
        'set-c',
      ]);
    },
  );

  test('searchHistory stays bounded with a large seeded history', () async {
    final seeded = <WorkoutSet>[];
    for (var index = 0; index < 240; index += 1) {
      final set = _set(
        id: 'set-${index.toString().padLeft(3, '0')}',
        performedAt: DateTime.utc(
          2026,
          5,
          27,
          12,
        ).subtract(Duration(minutes: index ~/ 3)),
        label: index.isEven
            ? WorkoutSetLabel.personalRecord
            : WorkoutSetLabel.warmup,
      );
      seeded.add(set);
      await repository.save(set);
    }
    final expectedIds =
        seeded
            .where((set) => set.label == WorkoutSetLabel.personalRecord)
            .toList()
          ..sort((a, b) {
            final performedAtComparison = b.performedAt.value.compareTo(
              a.performedAt.value,
            );
            if (performedAtComparison != 0) {
              return performedAtComparison;
            }
            return b.id.value.compareTo(a.id.value);
          });

    final page = await repository.searchHistory(
      WorkoutSetHistoryQuery(
        limit: 25,
        offset: 50,
        searchText: 'bench',
        labels: <WorkoutSetLabel>[WorkoutSetLabel.personalRecord],
      ),
    );

    expect(page.items, hasLength(25));
    expect(page.totalCount, 120);
    expect(page.hasMore, isTrue);
    expect(
      page.items.map((WorkoutSet set) => set.id.value),
      expectedIds
          .skip(50)
          .take(25)
          .map((WorkoutSet set) => set.id.value)
          .toList(growable: false),
    );
  });

  test(
    'timelineForExercise pages a large seeded history without gaps',
    () async {
      final exerciseRef = ExerciseRef.official(
        id: OfficialExerciseId('barbell-bench-press'),
        displayNameSnapshot: 'Bench',
      );
      for (var index = 0; index < 215; index += 1) {
        await repository.save(
          _set(
            id: 'set-${index.toString().padLeft(3, '0')}',
            performedAt: DateTime.utc(
              2026,
              5,
              27,
              12,
            ).subtract(Duration(minutes: index ~/ 4)),
          ),
        );
      }
      for (var index = 0; index < 25; index += 1) {
        await repository.save(
          _set(
            id: 'other-${index.toString().padLeft(3, '0')}',
            exerciseId: 'deadlift',
            exerciseDisplayNameSnapshot: 'Deadlift',
          ),
        );
      }

      final collectedIds = <String>[];
      WorkoutSetTimelineCursor? cursor;
      var hasMore = true;
      while (hasMore) {
        final page = await repository.timelineForExercise(
          WorkoutSetTimelineQuery(
            exerciseRef: exerciseRef,
            limit: 100,
            after: cursor,
          ),
        );
        collectedIds.addAll(page.items.map((WorkoutSet set) => set.id.value));
        cursor = page.nextCursor;
        hasMore = page.hasMore;
      }

      expect(collectedIds, hasLength(215));
      expect(collectedIds.toSet(), hasLength(215));
      expect(collectedIds.take(4), <String>[
        'set-003',
        'set-002',
        'set-001',
        'set-000',
      ]);
      expect(collectedIds.last, 'set-212');
    },
  );

  test(
    'dailySummary aggregates only the requested day and returns latest set',
    () async {
      await repository.save(
        _set(id: 'yesterday', performedAt: DateTime.utc(2026, 5, 26, 23)),
      );
      await repository.save(
        _set(id: 'today-a', performedAt: DateTime.utc(2026, 5, 27, 9)),
      );
      await repository.save(
        _set(
          id: 'today-c',
          repetitions: 8,
          loadKg: 50,
          performedAt: DateTime.utc(2026, 5, 27, 10),
        ),
      );
      await repository.save(
        _set(
          id: 'today-b',
          repetitions: 10,
          loadKg: 40,
          performedAt: DateTime.utc(2026, 5, 27, 10),
        ),
      );
      await repository.save(
        _set(id: 'tomorrow', performedAt: DateTime.utc(2026, 5, 28)),
      );

      final summary = await repository.dailySummary(
        WorkoutSetDailySummaryQuery(
          startInclusive: DateTime.utc(2026, 5, 27),
          endExclusive: DateTime.utc(2026, 5, 28),
        ),
      );

      expect(summary.setCount, 3);
      expect(summary.totalVolumeKg, 1300);
      expect(summary.lastLoggedSet?.id.value, 'today-c');
    },
  );

  test('searchHistory returns empty page for no matches', () async {
    await repository.save(_set(id: 'set-1'));

    final page = await repository.searchHistory(
      WorkoutSetHistoryQuery(limit: 10, offset: 0, searchText: 'deadlift'),
    );

    expect(page.items, isEmpty);
    expect(page.totalCount, 0);
    expect(page.hasMore, isFalse);
  });

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
  WorkoutSetLabel label = WorkoutSetLabel.none,
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
    label: label,
  );
}
