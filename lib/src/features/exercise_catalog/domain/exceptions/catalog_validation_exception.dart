final class CatalogValidationException implements Exception {
  const CatalogValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() {
    return 'CatalogValidationException($field): $message';
  }
}
