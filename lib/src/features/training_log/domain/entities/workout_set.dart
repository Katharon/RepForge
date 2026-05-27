import '../value_objects/exercise_ref.dart';
import '../value_objects/logged_set_values.dart';
import '../value_objects/set_label.dart';
import '../value_objects/stable_ids.dart';

final class WorkoutSet {
  const WorkoutSet({
    required this.id,
    required this.exerciseRef,
    required this.repetitions,
    required this.load,
    required this.performedAt,
    this.workoutSessionId,
    this.comment,
    this.label = WorkoutSetLabel.none,
  });

  final WorkoutSetId id;
  final ExerciseRef exerciseRef;
  final WorkoutSessionId? workoutSessionId;
  final Repetitions repetitions;
  final LoadKg load;
  final PerformedAt performedAt;
  final SetComment? comment;
  final WorkoutSetLabel label;

  @override
  bool operator ==(Object other) {
    return other is WorkoutSet &&
        other.id == id &&
        other.exerciseRef == exerciseRef &&
        other.workoutSessionId == workoutSessionId &&
        other.repetitions == repetitions &&
        other.load == load &&
        other.performedAt == performedAt &&
        other.comment == comment &&
        other.label == label;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      exerciseRef,
      workoutSessionId,
      repetitions,
      load,
      performedAt,
      comment,
      label,
    );
  }
}
