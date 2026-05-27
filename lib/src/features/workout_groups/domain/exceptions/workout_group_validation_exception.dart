final class WorkoutGroupValidationException implements Exception {
  const WorkoutGroupValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() {
    return 'WorkoutGroupValidationException($field): $message';
  }
}
