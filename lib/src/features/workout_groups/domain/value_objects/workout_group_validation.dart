import '../exceptions/workout_group_validation_exception.dart';

String requireWorkoutGroupText(String field, String value, {int? maxLength}) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw WorkoutGroupValidationException(field, 'Value must not be blank.');
  }

  if (maxLength != null && normalized.length > maxLength) {
    throw WorkoutGroupValidationException(
      field,
      'Value must be at most $maxLength characters.',
    );
  }

  return normalized;
}

int requireNonNegativeInt(String field, int value) {
  if (value < 0) {
    throw WorkoutGroupValidationException(field, 'Value must not be negative.');
  }

  return value;
}

int requirePageLimit(String field, int value) {
  if (value <= 0 || value > 100) {
    throw WorkoutGroupValidationException(
      field,
      'Limit must be between 1 and 100.',
    );
  }

  return value;
}
