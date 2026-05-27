final class AnalyticsValidationException implements Exception {
  const AnalyticsValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'AnalyticsValidationException($field): $message';
}
