import 'workout_group_validation.dart';

final class WorkoutGroupName {
  WorkoutGroupName(String value)
    : value = requireWorkoutGroupText('workoutGroupName', value, maxLength: 80);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is WorkoutGroupName && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class WorkoutGroupSortOrder {
  WorkoutGroupSortOrder(int value)
    : value = requireNonNegativeInt('workoutGroupSortOrder', value);

  final int value;

  @override
  bool operator ==(Object other) {
    return other is WorkoutGroupSortOrder && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class AssignmentPosition {
  AssignmentPosition(int value)
    : value = requireNonNegativeInt('assignmentPosition', value);

  final int value;

  @override
  bool operator ==(Object other) {
    return other is AssignmentPosition && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
