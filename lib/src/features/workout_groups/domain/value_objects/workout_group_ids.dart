import 'workout_group_validation.dart';

final class WorkoutGroupId {
  WorkoutGroupId(String value)
    : value = requireWorkoutGroupText('workoutGroupId', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is WorkoutGroupId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class WorkoutGroupExerciseAssignmentId {
  WorkoutGroupExerciseAssignmentId(String value)
    : value = requireWorkoutGroupText(
        'workoutGroupExerciseAssignmentId',
        value,
      );

  final String value;

  @override
  bool operator ==(Object other) {
    return other is WorkoutGroupExerciseAssignmentId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
