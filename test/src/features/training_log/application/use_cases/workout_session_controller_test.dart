import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/training_log/application/training_log_application.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  test('starts a lightweight active session from a Train category', () async {
    final repository = _InMemoryWorkoutSetRepository();
    final controller = WorkoutSessionController(
      workoutSetRepository: repository,
      workoutSessionIdProvider: () => WorkoutSessionId('session-1'),
      nowProvider: () => DateTime.utc(2026, 6, 6, 9),
    );

    final session = await controller.start(
      sourceName: 'Push',
      exerciseRefs: [_benchRef, _pressRef],
    );

    expect(session.id, WorkoutSessionId('session-1'));
    expect(session.source.name, 'Push');
    expect(session.source.plannedExerciseCount, 2);
    expect(controller.snapshot.active, session);
    expect(controller.snapshot.activeSummary?.setCount, 0);
    await controller.dispose();
  });

  test('refreshes active summary from sets saved with the session id', () async {
    final repository = _InMemoryWorkoutSetRepository();
    var now = DateTime.utc(2026, 6, 6, 9);
    final controller = WorkoutSessionController(
      workoutSetRepository: repository,
      workoutSessionIdProvider: () => WorkoutSessionId('session-1'),
      nowProvider: () => now,
    );
    await controller.start(sourceName: 'Push', exerciseRefs: [_benchRef]);
    await repository.save(
      _set(id: 'set-1', sessionId: 'session-1', exerciseRef: _benchRef),
    );
    await repository.save(
      _set(
        id: 'set-2',
        sessionId: 'session-1',
        exerciseRef: _pressRef,
        loadKg: 24,
        repetitions: 10,
      ),
    );
    await repository.save(_set(id: 'standalone'));
    now = DateTime.utc(2026, 6, 6, 9, 30);

    await controller.refreshActiveSummary();

    final summary = controller.snapshot.activeSummary!;
    expect(summary.setCount, 2);
    expect(summary.exerciseCount, 2);
    expect(summary.totalVolumeKg, 880);
    expect(summary.duration, const Duration(minutes: 30));
    await controller.dispose();
  });

  test('completes session with compact summary and clears active session', () async {
    final repository = _InMemoryWorkoutSetRepository();
    var now = DateTime.utc(2026, 6, 6, 9);
    final controller = WorkoutSessionController(
      workoutSetRepository: repository,
      workoutSessionIdProvider: () => WorkoutSessionId('session-1'),
      nowProvider: () => now,
    );
    await controller.start(sourceName: 'Pull');
    await repository.save(
      _set(id: 'set-1', sessionId: 'session-1', exerciseRef: _benchRef),
    );
    now = DateTime.utc(2026, 6, 6, 10, 5);

    final completed = await controller.complete();

    expect(completed, isNotNull);
    expect(controller.snapshot.active, isNull);
    expect(controller.snapshot.completedSummary, completed);
    expect(completed!.status, WorkoutSessionStatus.completed);
    expect(completed.duration, const Duration(hours: 1, minutes: 5));
    expect(completed.topExercise?.exerciseRef, _benchRef);
    await controller.dispose();
  });

  test('emits snapshots for UI listeners', () async {
    final repository = _InMemoryWorkoutSetRepository();
    final controller = WorkoutSessionController(
      workoutSetRepository: repository,
      workoutSessionIdProvider: () => WorkoutSessionId('session-1'),
      nowProvider: () => DateTime.utc(2026, 6, 6, 9),
    );
    final snapshots = <WorkoutSessionSnapshot>[];
    final subscription = controller.changes.listen(snapshots.add);

    await controller.start(sourceName: 'Legs');
    await controller.complete();

    expect(snapshots, hasLength(2));
    expect(snapshots.first.hasActiveSession, isTrue);
    expect(snapshots.last.completedSummary?.status, WorkoutSessionStatus.completed);
    await subscription.cancel();
    await controller.dispose();
  });
}

final _benchRef = ExerciseRef.official(
  id: OfficialExerciseId('barbell_bench_press'),
  displayNameSnapshot: 'Barbell Bench Press',
  catalogVersionSnapshot: '2026.06.0',
);

final _pressRef = ExerciseRef.official(
  id: OfficialExerciseId('dumbbell_shoulder_press'),
  displayNameSnapshot: 'Dumbbell Shoulder Press',
  catalogVersionSnapshot: '2026.06.0',
);

WorkoutSet _set({
  required String id,
  String? sessionId,
  ExerciseRef? exerciseRef,
  double loadKg = 80,
  int repetitions = 8,
}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: exerciseRef ?? _benchRef,
    workoutSessionId: sessionId == null ? null : WorkoutSessionId(sessionId),
    repetitions: Repetitions(repetitions),
    load: LoadKg(loadKg),
    performedAt: PerformedAt(DateTime.utc(2026, 6, 6, 9, 5)),
  );
}

final class _InMemoryWorkoutSetRepository implements WorkoutSetRepository {
  final _sets = <WorkoutSet>[];

  @override
  Future<void> save(WorkoutSet set) async {
    _sets.add(set);
  }

  @override
  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  ) async {
    return _sets
        .where((set) => set.workoutSessionId == workoutSessionId)
        .toList(growable: false);
  }

  @override
  Future<void> deleteById(WorkoutSetId id) {
    throw UnimplementedError();
  }

  @override
  Future<WorkoutSetDailySummary> dailySummary(
    WorkoutSetDailySummaryQuery query,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<WorkoutSet?> findById(WorkoutSetId id) {
    throw UnimplementedError();
  }

  @override
  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef) {
    throw UnimplementedError();
  }

  @override
  Future<WorkoutSetHistoryPage> searchHistory(WorkoutSetHistoryQuery query) {
    throw UnimplementedError();
  }

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) {
    throw UnimplementedError();
  }
}
