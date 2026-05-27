final class RestTimerValidationException implements Exception {
  const RestTimerValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'RestTimerValidationException($field): $message';
}
