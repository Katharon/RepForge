import '../entities/workout_set.dart';
import '../exceptions/training_log_validation_exception.dart';
import 'exercise_ref.dart';
import 'stable_ids.dart';

final class WorkoutSetTimelineCursor {
  WorkoutSetTimelineCursor({
    required DateTime performedAt,
    required this.workoutSetId,
  }) : performedAt = performedAt.toUtc();

  factory WorkoutSetTimelineCursor.fromSet(WorkoutSet set) {
    return WorkoutSetTimelineCursor(
      performedAt: set.performedAt.value,
      workoutSetId: set.id,
    );
  }

  final DateTime performedAt;
  final WorkoutSetId workoutSetId;

  @override
  bool operator ==(Object other) {
    return other is WorkoutSetTimelineCursor &&
        other.performedAt == performedAt &&
        other.workoutSetId == workoutSetId;
  }

  @override
  int get hashCode => Object.hash(performedAt, workoutSetId);
}

final class WorkoutSetTimelineQuery {
  WorkoutSetTimelineQuery({
    required this.exerciseRef,
    required int limit,
    this.after,
  }) : limit = _requireTimelineLimit(limit);

  final ExerciseRef exerciseRef;
  final int limit;
  final WorkoutSetTimelineCursor? after;
}

final class WorkoutSetTimelinePage {
  WorkoutSetTimelinePage({
    required Iterable<WorkoutSet> items,
    required this.hasMore,
    required this.nextCursor,
  }) : items = List<WorkoutSet>.unmodifiable(items);

  final List<WorkoutSet> items;
  final bool hasMore;
  final WorkoutSetTimelineCursor? nextCursor;
}

int _requireTimelineLimit(int value) {
  if (value <= 0 || value > 100) {
    throw TrainingLogValidationException(
      'workoutSetTimeline.limit',
      'Must be between 1 and 100.',
    );
  }

  return value;
}
