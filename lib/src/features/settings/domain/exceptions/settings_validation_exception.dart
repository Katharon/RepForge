final class SettingsValidationException implements Exception {
  const SettingsValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'SettingsValidationException($field): $message';
}
