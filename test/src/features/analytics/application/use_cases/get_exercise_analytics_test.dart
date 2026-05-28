import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/analytics/application/analytics_application.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  late _InMemoryWorkoutSetRepository repository;
  late GetExerciseAnalytics getExerciseAnalytics;

  setUp(() {
    repository = _InMemoryWorkoutSetRepository();
    getExerciseAnalytics = GetExerciseAnalytics(repository);
  });

  test('returns empty-safe metrics when history is empty', () async {
    final model = await getExerciseAnalytics(_query());

    expect(model.overview.setCount, 0);
    expect(model.overview.totalRepetitions, 0);
    expect(model.overview.totalVolumeKg, 0);
    expect(model.overview.averageKgPerRep.isAvailable, isFalse);
    expect(model.overview.bestEstimatedOneRepMaxKg.isAvailable, isFalse);
    expect(model.previousComparableSession.isAvailable, isFalse);
    expect(model.timeWindow.totalVolumeKgDelta.isAvailable, isFalse);
  });

  test('summarizes a single set', () async {
    repository.add(
      _set(
        id: 'set-1',
        loadKg: 100,
        repetitions: 5,
        performedAt: DateTime.utc(2026, 5, 20, 12),
      ),
    );

    final model = await getExerciseAnalytics(_query());

    expect(model.overview.setCount, 1);
    expect(model.overview.totalRepetitions, 5);
    expect(model.overview.totalVolumeKg, 500);
    expect(model.overview.averageKgPerRep.value, 100);
    expect(
      model.overview.bestEstimatedOneRepMaxKg.value,
      closeTo(116.6666667, 1e-6),
    );
  });

  test(
    'summarizes multiple sets and ignores sets outside the date window',
    () async {
      repository
        ..add(
          _set(
            id: 'current-1',
            loadKg: 100,
            repetitions: 5,
            performedAt: DateTime.utc(2026, 5, 20, 12),
          ),
        )
        ..add(
          _set(
            id: 'current-2',
            loadKg: 80,
            repetitions: 10,
            performedAt: DateTime.utc(2026, 5, 19, 12),
          ),
        )
        ..add(
          _set(
            id: 'previous-window',
            loadKg: 60,
            repetitions: 10,
            performedAt: DateTime.utc(2026, 5, 10, 12),
          ),
        )
        ..add(
          _set(
            id: 'outside-window',
            loadKg: 200,
            repetitions: 5,
            performedAt: DateTime.utc(2026, 5, 22, 12),
          ),
        );

      final model = await getExerciseAnalytics(_query());

      expect(model.overview.setCount, 2);
      expect(model.overview.totalRepetitions, 15);
      expect(model.overview.totalVolumeKg, 1300);
      expect(model.overview.averageKgPerRep.value, closeTo(86.6666667, 1e-6));
      expect(model.timeWindow.totalVolumeKgDelta.current, 1300);
      expect(model.timeWindow.totalVolumeKgDelta.previous, 600);
    },
  );

  test('handles zero-load sets and zero baselines explicitly', () async {
    repository
      ..add(
        _set(
          id: 'current-zero',
          loadKg: 0,
          repetitions: 10,
          performedAt: DateTime.utc(2026, 5, 20, 12),
        ),
      )
      ..add(
        _set(
          id: 'previous-zero',
          loadKg: 0,
          repetitions: 10,
          performedAt: DateTime.utc(2026, 5, 10, 12),
        ),
      );

    final model = await getExerciseAnalytics(_query());

    expect(model.overview.totalVolumeKg, 0);
    expect(model.overview.averageKgPerRep.value, 0);
    expect(model.overview.bestEstimatedOneRepMaxKg.value, 0);
    expect(model.timeWindow.totalVolumeKgDelta.current, 0);
    expect(model.timeWindow.totalVolumeKgDelta.previous, 0);
    expect(model.timeWindow.totalVolumeKgDelta.absoluteDelta, 0);
    expect(model.timeWindow.totalVolumeKgDelta.percentChange, isNull);
  });

  test(
    'returns unavailable previous comparable session when no baseline exists',
    () async {
      repository.add(
        _set(
          id: 'current',
          loadKg: 100,
          repetitions: 5,
          performedAt: DateTime.utc(2026, 5, 20, 12),
        ),
      );

      final model = await getExerciseAnalytics(_query());

      expect(model.previousComparableSession.isAvailable, isFalse);
      expect(
        model.previousComparableSession.totalVolumeKgDelta.previous,
        isNull,
      );
    },
  );

  test(
    'calculates positive, negative, and equal previous comparable deltas',
    () async {
      final positive = await _modelForComparableVolumes(
        currentVolumeKg: 1000,
        previousVolumeKg: 800,
      );
      final negative = await _modelForComparableVolumes(
        currentVolumeKg: 600,
        previousVolumeKg: 800,
      );
      final equal = await _modelForComparableVolumes(
        currentVolumeKg: 800,
        previousVolumeKg: 800,
      );

      expect(
        positive.previousComparableSession.totalVolumeKgDelta.absoluteDelta,
        200,
      );
      expect(
        positive.previousComparableSession.totalVolumeKgDelta.percentChange,
        0.25,
      );
      expect(
        negative.previousComparableSession.totalVolumeKgDelta.absoluteDelta,
        -200,
      );
      expect(
        equal.previousComparableSession.totalVolumeKgDelta.absoluteDelta,
        0,
      );
      expect(
        equal.previousComparableSession.totalVolumeKgDelta.percentChange,
        0,
      );
    },
  );

  test(
    'uses workout session id before UTC day fallback for comparable groups',
    () async {
      repository
        ..add(
          _set(
            id: 'current-a',
            workoutSessionId: 'session-current',
            loadKg: 100,
            repetitions: 5,
            performedAt: DateTime.utc(2026, 5, 20, 12),
          ),
        )
        ..add(
          _set(
            id: 'current-b',
            workoutSessionId: 'session-current',
            loadKg: 100,
            repetitions: 5,
            performedAt: DateTime.utc(2026, 5, 20, 13),
          ),
        )
        ..add(
          _set(
            id: 'same-day-different-session',
            workoutSessionId: 'session-other',
            loadKg: 200,
            repetitions: 5,
            performedAt: DateTime.utc(2026, 5, 20, 10),
          ),
        )
        ..add(
          _set(
            id: 'previous',
            workoutSessionId: 'session-previous',
            loadKg: 80,
            repetitions: 10,
            performedAt: DateTime.utc(2026, 5, 10, 12),
          ),
        );

      final model = await getExerciseAnalytics(_query());

      expect(model.previousComparableSession.current.setCount, 2);
      expect(model.previousComparableSession.current.totalVolumeKg, 1000);
      expect(model.previousComparableSession.previous?.setCount, 1);
      expect(model.previousComparableSession.previous?.totalVolumeKg, 1000);
    },
  );

  test('falls back to performedAt UTC day when session id is absent', () async {
    repository
      ..add(
        _set(
          id: 'current-a',
          loadKg: 100,
          repetitions: 5,
          performedAt: DateTime.utc(2026, 5, 20, 12),
        ),
      )
      ..add(
        _set(
          id: 'current-b',
          loadKg: 100,
          repetitions: 5,
          performedAt: DateTime.utc(2026, 5, 20, 13),
        ),
      )
      ..add(
        _set(
          id: 'previous-day',
          loadKg: 80,
          repetitions: 10,
          performedAt: DateTime.utc(2026, 5, 10, 12),
        ),
      );

    final model = await getExerciseAnalytics(_query());

    expect(model.previousComparableSession.current.totalVolumeKg, 1000);
    expect(model.previousComparableSession.previous?.totalVolumeKg, 800);
  });

  test(
    'calculates current time window versus previous equal-length window',
    () async {
      repository
        ..add(
          _set(
            id: 'current',
            loadKg: 100,
            repetitions: 10,
            performedAt: DateTime.utc(2026, 5, 20, 12),
          ),
        )
        ..add(
          _set(
            id: 'previous',
            loadKg: 80,
            repetitions: 10,
            performedAt: DateTime.utc(2026, 5, 10, 12),
          ),
        );

      final model = await getExerciseAnalytics(_query());

      expect(model.timeWindow.current.totalVolumeKg, 1000);
      expect(model.timeWindow.previous?.totalVolumeKg, 800);
      expect(model.timeWindow.totalVolumeKgDelta.absoluteDelta, 200);
      expect(model.timeWindow.totalVolumeKgDelta.percentChange, 0.25);
    },
  );

  test(
    'uses bounded timeline reads and does not call unbounded history',
    () async {
      for (var index = 0; index < 125; index += 1) {
        repository.add(
          _set(
            id: 'set-$index',
            loadKg: 100,
            repetitions: 5,
            performedAt: DateTime.utc(
              2026,
              5,
              20,
            ).subtract(Duration(hours: index)),
          ),
        );
      }

      final model = await getExerciseAnalytics(_query(maxHistorySets: 75));

      expect(repository.historyForExerciseCalled, isFalse);
      expect(repository.timelineQueries, isNotEmpty);
      expect(
        repository.timelineQueries.every(
          (WorkoutSetTimelineQuery query) => query.limit <= 100,
        ),
        isTrue,
      );
      expect(model.scannedSetCount, 75);
      expect(model.reachedHistoryLimit, isTrue);
    },
  );

  test('does not mutate input WorkoutSets', () async {
    final original = <WorkoutSet>[
      _set(
        id: 'set-1',
        loadKg: 100,
        repetitions: 5,
        performedAt: DateTime.utc(2026, 5, 20, 12),
      ),
      _set(
        id: 'set-2',
        loadKg: 80,
        repetitions: 10,
        performedAt: DateTime.utc(2026, 5, 19, 12),
      ),
    ];
    repository.sets.addAll(original);
    final snapshot = List<WorkoutSet>.of(original);

    await getExerciseAnalytics(_query());

    expect(repository.sets, snapshot);
  });
}

Future<ExerciseAnalyticsReadModel> _modelForComparableVolumes({
  required num currentVolumeKg,
  required num previousVolumeKg,
}) async {
  final repository = _InMemoryWorkoutSetRepository()
    ..add(
      _set(
        id: 'current',
        loadKg: currentVolumeKg / 10,
        repetitions: 10,
        performedAt: DateTime.utc(2026, 5, 20, 12),
      ),
    )
    ..add(
      _set(
        id: 'previous',
        loadKg: previousVolumeKg / 10,
        repetitions: 10,
        performedAt: DateTime.utc(2026, 5, 10, 12),
      ),
    );

  return GetExerciseAnalytics(repository)(_query());
}

ExerciseAnalyticsQuery _query({int maxHistorySets = 200}) {
  return ExerciseAnalyticsQuery(
    exerciseRef: _exerciseRef(),
    period: ExerciseAnalyticsPeriod(
      start: DateTime.utc(2026, 5, 14),
      end: DateTime.utc(2026, 5, 21),
    ),
    maxHistorySets: maxHistorySets,
  );
}

WorkoutSet _set({
  required String id,
  required num loadKg,
  required int repetitions,
  required DateTime performedAt,
  String? workoutSessionId,
  ExerciseRef? exerciseRef,
}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: exerciseRef ?? _exerciseRef(),
    workoutSessionId: workoutSessionId == null
        ? null
        : WorkoutSessionId(workoutSessionId),
    repetitions: Repetitions(repetitions),
    load: LoadKg(loadKg),
    performedAt: PerformedAt(performedAt),
  );
}

ExerciseRef _exerciseRef() {
  return ExerciseRef.official(
    id: OfficialExerciseId('barbell-bench-press'),
    displayNameSnapshot: 'Barbell Bench Press',
    catalogVersionSnapshot: '2026.05.0',
  );
}

final class _InMemoryWorkoutSetRepository implements WorkoutSetRepository {
  final List<WorkoutSet> sets = <WorkoutSet>[];
  final List<WorkoutSetTimelineQuery> timelineQueries =
      <WorkoutSetTimelineQuery>[];
  var historyForExerciseCalled = false;

  void add(WorkoutSet set) {
    sets.add(set);
  }

  @override
  Future<void> save(WorkoutSet set) async {
    final existingIndex = sets.indexWhere(
      (WorkoutSet existing) => existing.id == set.id,
    );
    if (existingIndex == -1) {
      sets.add(set);
    } else {
      sets[existingIndex] = set;
    }
  }

  @override
  Future<void> deleteById(WorkoutSetId id) async {
    sets.removeWhere((WorkoutSet set) => set.id == id);
  }

  @override
  Future<WorkoutSet?> findById(WorkoutSetId id) async {
    for (final set in sets) {
      if (set.id == id) {
        return set;
      }
    }

    return null;
  }

  @override
  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef) async {
    historyForExerciseCalled = true;
    return sets
        .where((WorkoutSet set) => _sameExercise(set.exerciseRef, exerciseRef))
        .toList(growable: false);
  }

  @override
  Future<WorkoutSetHistoryPage> searchHistory(
    WorkoutSetHistoryQuery query,
  ) async {
    return WorkoutSetHistoryPage(
      items: sets.skip(query.offset).take(query.limit),
      totalCount: sets.length,
      limit: query.limit,
      offset: query.offset,
    );
  }

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) async {
    timelineQueries.add(query);
    final sorted =
        sets
            .where(
              (WorkoutSet set) =>
                  _sameExercise(set.exerciseRef, query.exerciseRef),
            )
            .toList()
          ..sort((WorkoutSet a, WorkoutSet b) {
            final performedAtComparison = b.performedAt.value.compareTo(
              a.performedAt.value,
            );
            if (performedAtComparison != 0) {
              return performedAtComparison;
            }

            return b.id.value.compareTo(a.id.value);
          });
    final after = query.after;
    final filtered = after == null
        ? sorted
        : sorted
              .where((WorkoutSet set) {
                final performedAt = set.performedAt.value;
                return performedAt.isBefore(after.performedAt) ||
                    (performedAt == after.performedAt &&
                        set.id.value.compareTo(after.workoutSetId.value) < 0);
              })
              .toList(growable: false);
    final items = filtered.take(query.limit).toList(growable: false);

    return WorkoutSetTimelinePage(
      items: items,
      hasMore: filtered.length > query.limit,
      nextCursor: filtered.length > query.limit && items.isNotEmpty
          ? WorkoutSetTimelineCursor.fromSet(items.last)
          : null,
    );
  }

  @override
  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  ) async {
    return sets
        .where((WorkoutSet set) => set.workoutSessionId == workoutSessionId)
        .toList(growable: false);
  }

  bool _sameExercise(ExerciseRef a, ExerciseRef b) {
    return a.source == b.source && a.id == b.id;
  }
}
