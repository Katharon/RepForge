final class EntitlementValidationException implements Exception {
  const EntitlementValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'EntitlementValidationException($field): $message';
}
