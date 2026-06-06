import 'dart:async';

import '../../domain/training_log_domain.dart';

typedef WorkoutSessionIdProvider = WorkoutSessionId Function();
typedef WorkoutSessionNowProvider = DateTime Function();

final class WorkoutSessionController {
  WorkoutSessionController({
    required this.workoutSetRepository,
    this.workoutSessionIdProvider = _defaultWorkoutSessionId,
    this.nowProvider = DateTime.now,
  });

  final WorkoutSetRepository workoutSetRepository;
  final WorkoutSessionIdProvider workoutSessionIdProvider;
  final WorkoutSessionNowProvider nowProvider;
  final StreamController<WorkoutSessionSnapshot> _changes =
      StreamController<WorkoutSessionSnapshot>.broadcast(sync: true);

  var _snapshot = const WorkoutSessionSnapshot();

  WorkoutSessionSnapshot get snapshot => _snapshot;

  Stream<WorkoutSessionSnapshot> get changes => _changes.stream;

  Future<ActiveWorkoutSession> start({
    required String sourceName,
    Iterable<ExerciseRef> exerciseRefs = const <ExerciseRef>[],
  }) async {
    final session = ActiveWorkoutSession(
      id: workoutSessionIdProvider(),
      source: WorkoutSessionSource(
        name: sourceName,
        exerciseRefs: exerciseRefs,
      ),
      startedAt: nowProvider(),
    );
    _snapshot = WorkoutSessionSnapshot(
      active: session,
      activeSummary: WorkoutSessionSummary.fromSets(
        session: session,
        status: WorkoutSessionStatus.active,
        sets: const <WorkoutSet>[],
        measuredAt: nowProvider(),
      ),
    );
    _emit();
    return session;
  }

  Future<void> refreshActiveSummary() async {
    final active = _snapshot.active;
    if (active == null) {
      return;
    }
    final summary = await _summaryFor(active, WorkoutSessionStatus.active);
    _snapshot = WorkoutSessionSnapshot(
      active: active,
      activeSummary: summary,
      completedSummary: _snapshot.completedSummary,
    );
    _emit();
  }

  Future<WorkoutSessionSummary?> complete() async {
    final active = _snapshot.active;
    if (active == null) {
      return null;
    }
    final completedAt = nowProvider();
    final summary = await _summaryFor(
      active,
      WorkoutSessionStatus.completed,
      completedAt: completedAt,
    );
    _snapshot = WorkoutSessionSnapshot(completedSummary: summary);
    _emit();
    return summary;
  }

  Future<void> abandon() async {
    final active = _snapshot.active;
    if (active == null) {
      return;
    }
    _snapshot = WorkoutSessionSnapshot(
      completedSummary: WorkoutSessionSummary.fromSets(
        session: active,
        status: WorkoutSessionStatus.abandoned,
        sets: const <WorkoutSet>[],
        measuredAt: nowProvider(),
        completedAt: nowProvider(),
      ),
    );
    _emit();
  }

  Future<WorkoutSessionSummary> _summaryFor(
    ActiveWorkoutSession session,
    WorkoutSessionStatus status, {
    DateTime? completedAt,
  }) async {
    final sets = await workoutSetRepository.setsForWorkoutSession(session.id);
    return WorkoutSessionSummary.fromSets(
      session: session,
      status: status,
      sets: sets,
      measuredAt: completedAt ?? nowProvider(),
      completedAt: completedAt,
    );
  }

  void _emit() {
    if (!_changes.isClosed) {
      _changes.add(_snapshot);
    }
  }

  Future<void> dispose() async {
    await _changes.close();
  }
}

WorkoutSessionId _defaultWorkoutSessionId() {
  return WorkoutSessionId(
    'session_${DateTime.now().toUtc().microsecondsSinceEpoch}',
  );
}
