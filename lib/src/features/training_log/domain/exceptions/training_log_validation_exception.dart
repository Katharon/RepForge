final class TrainingLogValidationException implements Exception {
  const TrainingLogValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'TrainingLogValidationException($field): $message';
}
