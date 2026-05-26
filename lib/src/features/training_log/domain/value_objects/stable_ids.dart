import 'training_log_validation.dart';

final class WorkoutSetId {
  WorkoutSetId(String value) : value = requireNonBlank('workoutSetId', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is WorkoutSetId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class WorkoutSessionId {
  WorkoutSessionId(String value)
    : value = requireNonBlank('workoutSessionId', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is WorkoutSessionId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class OfficialExerciseId {
  OfficialExerciseId(String value)
    : value = requireNonBlank('officialExerciseId', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is OfficialExerciseId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class CustomExerciseId {
  CustomExerciseId(String value)
    : value = requireNonBlank('customExerciseId', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is CustomExerciseId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
