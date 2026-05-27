import '../../../training_log/domain/training_log_domain.dart';
import '../value_objects/workout_group_ids.dart';
import '../value_objects/workout_group_values.dart';

final class WorkoutGroupExerciseAssignment {
  const WorkoutGroupExerciseAssignment({
    required this.id,
    required this.workoutGroupId,
    required this.exerciseRef,
    required this.position,
  });

  final WorkoutGroupExerciseAssignmentId id;
  final WorkoutGroupId workoutGroupId;
  final ExerciseRef exerciseRef;
  final AssignmentPosition position;

  @override
  bool operator ==(Object other) {
    return other is WorkoutGroupExerciseAssignment &&
        other.id == id &&
        other.workoutGroupId == workoutGroupId &&
        other.exerciseRef == exerciseRef &&
        other.position == position;
  }

  @override
  int get hashCode => Object.hash(id, workoutGroupId, exerciseRef, position);
}
