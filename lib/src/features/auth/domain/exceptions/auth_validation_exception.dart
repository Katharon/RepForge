final class AuthValidationException implements Exception {
  const AuthValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'AuthValidationException($field)';
}
