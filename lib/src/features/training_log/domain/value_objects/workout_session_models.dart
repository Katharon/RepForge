import '../entities/workout_set.dart';
import 'exercise_ref.dart';
import 'stable_ids.dart';
import 'training_log_validation.dart';

enum WorkoutSessionStatus { active, completed, abandoned }

final class WorkoutSessionSource {
  WorkoutSessionSource({
    required String name,
    Iterable<ExerciseRef> exerciseRefs = const <ExerciseRef>[],
  }) : name = requireNonBlank('workoutSessionSource.name', name),
       exerciseRefs = List<ExerciseRef>.unmodifiable(exerciseRefs);

  final String name;
  final List<ExerciseRef> exerciseRefs;

  int get plannedExerciseCount => exerciseRefs.length;

  @override
  bool operator ==(Object other) {
    return other is WorkoutSessionSource &&
        other.name == name &&
        _listEquals(other.exerciseRefs, exerciseRefs);
  }

  @override
  int get hashCode => Object.hash(name, Object.hashAll(exerciseRefs));
}

final class ActiveWorkoutSession {
  ActiveWorkoutSession({
    required this.id,
    required this.source,
    required DateTime startedAt,
  }) : startedAt = startedAt.toUtc();

  final WorkoutSessionId id;
  final WorkoutSessionSource source;
  final DateTime startedAt;

  Duration elapsedAt(DateTime now) {
    final elapsed = now.toUtc().difference(startedAt);
    return elapsed.isNegative ? Duration.zero : elapsed;
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveWorkoutSession &&
        other.id == id &&
        other.source == source &&
        other.startedAt == startedAt;
  }

  @override
  int get hashCode => Object.hash(id, source, startedAt);
}

final class WorkoutSessionExerciseProgress {
  const WorkoutSessionExerciseProgress({
    required this.exerciseRef,
    required this.setCount,
    required this.totalVolumeKg,
  });

  final ExerciseRef exerciseRef;
  final int setCount;
  final double totalVolumeKg;

  @override
  bool operator ==(Object other) {
    return other is WorkoutSessionExerciseProgress &&
        other.exerciseRef == exerciseRef &&
        other.setCount == setCount &&
        other.totalVolumeKg == totalVolumeKg;
  }

  @override
  int get hashCode => Object.hash(exerciseRef, setCount, totalVolumeKg);
}

final class WorkoutSessionSummary {
  WorkoutSessionSummary({
    required this.id,
    required this.source,
    required this.status,
    required DateTime startedAt,
    required DateTime measuredAt,
    required Iterable<WorkoutSessionExerciseProgress> exerciseProgress,
    this.completedAt,
  }) : startedAt = startedAt.toUtc(),
       measuredAt = measuredAt.toUtc(),
       completedAt = completedAt?.toUtc(),
       exerciseProgress = List<WorkoutSessionExerciseProgress>.unmodifiable(
         exerciseProgress,
       );

  factory WorkoutSessionSummary.fromSets({
    required ActiveWorkoutSession session,
    required WorkoutSessionStatus status,
    required Iterable<WorkoutSet> sets,
    required DateTime measuredAt,
    DateTime? completedAt,
  }) {
    final progress = <ExerciseRef, _MutableExerciseProgress>{};
    for (final set in sets) {
      progress
          .putIfAbsent(
            set.exerciseRef,
            () => _MutableExerciseProgress(exerciseRef: set.exerciseRef),
          )
          .add(set);
    }

    return WorkoutSessionSummary(
      id: session.id,
      source: session.source,
      status: status,
      startedAt: session.startedAt,
      measuredAt: measuredAt,
      completedAt: completedAt,
      exerciseProgress: progress.values
          .map(
            (entry) => WorkoutSessionExerciseProgress(
              exerciseRef: entry.exerciseRef,
              setCount: entry.setCount,
              totalVolumeKg: entry.totalVolumeKg,
            ),
          )
          .toList(growable: false),
    );
  }

  final WorkoutSessionId id;
  final WorkoutSessionSource source;
  final WorkoutSessionStatus status;
  final DateTime startedAt;
  final DateTime measuredAt;
  final DateTime? completedAt;
  final List<WorkoutSessionExerciseProgress> exerciseProgress;

  Duration get duration {
    final end = completedAt ?? measuredAt;
    final elapsed = end.difference(startedAt);
    return elapsed.isNegative ? Duration.zero : elapsed;
  }

  int get setCount {
    return exerciseProgress.fold<int>(
      0,
      (total, progress) => total + progress.setCount,
    );
  }

  int get exerciseCount => exerciseProgress.length;

  double get totalVolumeKg {
    return exerciseProgress.fold<double>(
      0,
      (total, progress) => total + progress.totalVolumeKg,
    );
  }

  WorkoutSessionExerciseProgress? get topExercise {
    WorkoutSessionExerciseProgress? top;
    for (final progress in exerciseProgress) {
      if (top == null ||
          progress.totalVolumeKg > top.totalVolumeKg ||
          (progress.totalVolumeKg == top.totalVolumeKg &&
              progress.setCount > top.setCount)) {
        top = progress;
      }
    }
    return top;
  }
}

final class WorkoutSessionSnapshot {
  const WorkoutSessionSnapshot({
    this.active,
    this.activeSummary,
    this.completedSummary,
  });

  final ActiveWorkoutSession? active;
  final WorkoutSessionSummary? activeSummary;
  final WorkoutSessionSummary? completedSummary;

  bool get hasActiveSession => active != null;
}

final class _MutableExerciseProgress {
  _MutableExerciseProgress({required this.exerciseRef});

  final ExerciseRef exerciseRef;
  int setCount = 0;
  double totalVolumeKg = 0;

  void add(WorkoutSet set) {
    setCount += 1;
    totalVolumeKg += set.load.value * set.repetitions.value;
  }
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}
