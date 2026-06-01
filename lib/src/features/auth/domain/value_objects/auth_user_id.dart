import '../exceptions/auth_validation_exception.dart';

final class AuthUserId {
  const AuthUserId._(this.value);

  factory AuthUserId(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw const AuthValidationException('authUserId', 'Must not be empty.');
    }
    return AuthUserId._(normalized);
  }

  final String value;

  @override
  bool operator ==(Object other) {
    return other is AuthUserId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
