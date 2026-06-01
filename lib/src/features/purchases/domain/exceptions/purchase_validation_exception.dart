final class PurchaseValidationException implements Exception {
  const PurchaseValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'PurchaseValidationException($field): $message';
}
