final class RecoveryValidationException implements Exception {
  const RecoveryValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'RecoveryValidationException($field): $message';
}
