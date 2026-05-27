import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  group('stable ids', () {
    test('reject blank values', () {
      expect(
        () => WorkoutSetId(' '),
        throwsA(isA<TrainingLogValidationException>()),
      );
      expect(
        () => WorkoutSessionId(''),
        throwsA(isA<TrainingLogValidationException>()),
      );
      expect(
        () => OfficialExerciseId('\t'),
        throwsA(isA<TrainingLogValidationException>()),
      );
      expect(
        () => CustomExerciseId('\n'),
        throwsA(isA<TrainingLogValidationException>()),
      );
    });

    test('trim values and compare by value', () {
      expect(WorkoutSetId(' set-1 '), WorkoutSetId('set-1'));
      expect(WorkoutSessionId(' session-1 ').value, 'session-1');
      expect(OfficialExerciseId(' bench-press ').value, 'bench-press');
      expect(CustomExerciseId(' local-1 ').value, 'local-1');
    });
  });

  group('ExerciseRef', () {
    test('supports official references with catalog version snapshot', () {
      final ref = ExerciseRef.official(
        id: OfficialExerciseId('barbell-bench-press'),
        displayNameSnapshot: 'Barbell Bench Press',
        catalogVersionSnapshot: '2026.05.0',
      );

      expect(ref.source, ExerciseSource.official);
      expect(ref.id, 'barbell-bench-press');
      expect(ref.displayNameSnapshot, 'Barbell Bench Press');
      expect(ref.catalogVersionSnapshot, '2026.05.0');
    });

    test('supports custom references without catalog data', () {
      final ref = ExerciseRef.custom(
        id: CustomExerciseId('custom-row-1'),
        displayNameSnapshot: 'Cable Row Variant',
      );

      expect(ref.source, ExerciseSource.custom);
      expect(ref.id, 'custom-row-1');
      expect(ref.displayNameSnapshot, 'Cable Row Variant');
      expect(ref.catalogVersionSnapshot, isNull);
    });

    test('rejects blank display name snapshots', () {
      expect(
        () => ExerciseRef.official(
          id: OfficialExerciseId('squat'),
          displayNameSnapshot: ' ',
        ),
        throwsA(isA<TrainingLogValidationException>()),
      );
      expect(
        () => ExerciseRef.custom(
          id: CustomExerciseId('custom-1'),
          displayNameSnapshot: '',
        ),
        throwsA(isA<TrainingLogValidationException>()),
      );
    });
  });

  group('logged set value objects', () {
    test('Repetitions must be positive', () {
      expect(Repetitions(1).value, 1);
      expect(
        () => Repetitions(0),
        throwsA(isA<TrainingLogValidationException>()),
      );
      expect(
        () => Repetitions(-1),
        throwsA(isA<TrainingLogValidationException>()),
      );
    });

    test('LoadKg allows zero and rejects invalid loads', () {
      expect(LoadKg(0).value, 0);
      expect(LoadKg(125.5).value, 125.5);
      expect(
        () => LoadKg(-0.5),
        throwsA(isA<TrainingLogValidationException>()),
      );
      expect(
        () => LoadKg(double.nan),
        throwsA(isA<TrainingLogValidationException>()),
      );
      expect(
        () => LoadKg(double.infinity),
        throwsA(isA<TrainingLogValidationException>()),
      );
    });

    test('PerformedAt stores the provided timestamp', () {
      final timestamp = DateTime.utc(2026, 5, 27, 10, 30);

      expect(PerformedAt(timestamp).value, timestamp);
    });

    test('SetComment rejects blank comments when present', () {
      expect(SetComment(' Felt strong ').value, 'Felt strong');
      expect(
        () => SetComment(' '),
        throwsA(isA<TrainingLogValidationException>()),
      );
    });

    test('WorkoutSetLabel supports the compact MVP marker set', () {
      expect(WorkoutSetLabel.fromStorageValue(null), WorkoutSetLabel.none);
      expect(WorkoutSetLabel.fromStorageValue(''), WorkoutSetLabel.none);
      expect(WorkoutSetLabel.fromStorageValue('none'), WorkoutSetLabel.none);
      expect(
        WorkoutSetLabel.fromStorageValue('warmup'),
        WorkoutSetLabel.warmup,
      );
      expect(
        WorkoutSetLabel.fromStorageValue('failure'),
        WorkoutSetLabel.failure,
      );
      expect(
        WorkoutSetLabel.fromStorageValue('personalRecord'),
        WorkoutSetLabel.personalRecord,
      );
      expect(
        WorkoutSetLabel.fromStorageValue('dropSet'),
        WorkoutSetLabel.dropSet,
      );
      expect(WorkoutSetLabel.fromStorageValue('pain'), WorkoutSetLabel.pain);
    });

    test('WorkoutSetLabel rejects unsupported persisted labels', () {
      expect(
        () => WorkoutSetLabel.fromStorageValue('tempo'),
        throwsA(
          isA<TrainingLogValidationException>().having(
            (TrainingLogValidationException error) => error.field,
            'field',
            'setLabel',
          ),
        ),
      );
    });
  });

  group('WorkoutSet', () {
    test('defaults the set label to none', () {
      final set = _setForTimeline('set-default-label');

      expect(set.label, WorkoutSetLabel.none);
    });

    test(
      'keeps stable ids, snapshots, timestamp, optional session link, comment, and label',
      () {
        final performedAt = PerformedAt(DateTime.utc(2026, 5, 27, 10, 45));
        final exerciseRef = ExerciseRef.official(
          id: OfficialExerciseId('deadlift'),
          displayNameSnapshot: 'Deadlift',
          catalogVersionSnapshot: '2026.05.0',
        );

        final set = WorkoutSet(
          id: WorkoutSetId('set-1'),
          exerciseRef: exerciseRef,
          workoutSessionId: WorkoutSessionId('session-1'),
          repetitions: Repetitions(5),
          load: LoadKg(140),
          performedAt: performedAt,
          comment: SetComment('Top set'),
          label: WorkoutSetLabel.personalRecord,
        );

        expect(set.id, WorkoutSetId('set-1'));
        expect(set.exerciseRef, exerciseRef);
        expect(set.workoutSessionId, WorkoutSessionId('session-1'));
        expect(set.repetitions.value, 5);
        expect(set.load.value, 140);
        expect(set.performedAt, performedAt);
        expect(set.comment, SetComment('Top set'));
        expect(set.label, WorkoutSetLabel.personalRecord);
      },
    );
  });

  group('WorkoutSetTimeline', () {
    test('query requires a positive bounded limit', () {
      final exerciseRef = ExerciseRef.official(
        id: OfficialExerciseId('barbell-bench-press'),
        displayNameSnapshot: 'Bench',
      );

      expect(
        WorkoutSetTimelineQuery(exerciseRef: exerciseRef, limit: 1).limit,
        1,
      );
      expect(
        () => WorkoutSetTimelineQuery(exerciseRef: exerciseRef, limit: 0),
        throwsA(isA<TrainingLogValidationException>()),
      );
      expect(
        () => WorkoutSetTimelineQuery(exerciseRef: exerciseRef, limit: 101),
        throwsA(isA<TrainingLogValidationException>()),
      );
    });

    test('cursor uses performedAt and stable workoutSetId', () {
      final set = WorkoutSet(
        id: WorkoutSetId('set-cursor'),
        exerciseRef: ExerciseRef.official(
          id: OfficialExerciseId('deadlift'),
          displayNameSnapshot: 'Deadlift',
        ),
        repetitions: Repetitions(3),
        load: LoadKg(140),
        performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 12)),
      );

      final cursor = WorkoutSetTimelineCursor.fromSet(set);

      expect(cursor.performedAt, DateTime.utc(2026, 5, 27, 12));
      expect(cursor.workoutSetId, WorkoutSetId('set-cursor'));
      expect(
        WorkoutSetTimelineCursor(
          performedAt: DateTime.utc(2026, 5, 27, 12),
          workoutSetId: WorkoutSetId('set-cursor'),
        ),
        cursor,
      );
    });

    test('page stores immutable items and cursor state', () {
      final set = _setForTimeline('set-1');
      final cursor = WorkoutSetTimelineCursor.fromSet(set);
      final page = WorkoutSetTimelinePage(
        items: <WorkoutSet>[set],
        hasMore: true,
        nextCursor: cursor,
      );

      expect(page.items, <WorkoutSet>[set]);
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, cursor);
      expect(
        () => page.items.add(_setForTimeline('set-2')),
        throwsUnsupportedError,
      );
    });
  });

  test('WorkoutSetRepository contract compiles against domain types', () {
    final repository = _InMemoryWorkoutSetRepository();
    final set = WorkoutSet(
      id: WorkoutSetId('set-1'),
      exerciseRef: ExerciseRef.custom(
        id: CustomExerciseId('custom-1'),
        displayNameSnapshot: 'Home Row',
      ),
      repetitions: Repetitions(8),
      load: LoadKg(32),
      performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 11)),
    );

    expect(repository.save(set), completes);
    expect(repository.findById(WorkoutSetId('set-1')), completion(set));
    expect(
      repository.historyForExercise(set.exerciseRef),
      completion(<WorkoutSet>[set]),
    );
    expect(
      repository.setsForWorkoutSession(WorkoutSessionId('session-1')),
      completion(isEmpty),
    );
    expect(
      repository.timelineForExercise(
        WorkoutSetTimelineQuery(exerciseRef: set.exerciseRef, limit: 10),
      ),
      completion(isA<WorkoutSetTimelinePage>()),
    );
    expect(repository.deleteById(WorkoutSetId('set-1')), completes);
    expect(repository.findById(WorkoutSetId('set-1')), completion(isNull));
  });
}

WorkoutSet _setForTimeline(String id) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell-bench-press'),
      displayNameSnapshot: 'Bench',
    ),
    repetitions: Repetitions(5),
    load: LoadKg(100),
    performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 12)),
  );
}

final class _InMemoryWorkoutSetRepository implements WorkoutSetRepository {
  final Map<WorkoutSetId, WorkoutSet> _sets = <WorkoutSetId, WorkoutSet>{};

  @override
  Future<void> save(WorkoutSet set) async {
    _sets[set.id] = set;
  }

  @override
  Future<void> deleteById(WorkoutSetId id) async {
    _sets.remove(id);
  }

  @override
  Future<WorkoutSet?> findById(WorkoutSetId id) async => _sets[id];

  @override
  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef) async {
    return _sets.values
        .where((WorkoutSet set) => set.exerciseRef == exerciseRef)
        .toList(growable: false);
  }

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) async {
    final items = await historyForExercise(query.exerciseRef);
    return WorkoutSetTimelinePage(
      items: items.take(query.limit),
      hasMore: items.length > query.limit,
      nextCursor: items.length > query.limit && items.isNotEmpty
          ? WorkoutSetTimelineCursor.fromSet(items.take(query.limit).last)
          : null,
    );
  }

  @override
  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  ) async {
    return _sets.values
        .where((WorkoutSet set) => set.workoutSessionId == workoutSessionId)
        .toList(growable: false);
  }
}
