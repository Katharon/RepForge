import '../exceptions/auth_validation_exception.dart';

final class AuthFailure {
  const AuthFailure({required this.code, required this.message})
    : assert(code.length > 0),
      assert(message.length > 0);

  factory AuthFailure.safe({required String code, required String message}) {
    final normalizedCode = code.trim();
    final normalizedMessage = message.trim();
    if (normalizedCode.isEmpty) {
      throw const AuthValidationException(
        'authFailure.code',
        'Must not be empty.',
      );
    }
    if (normalizedMessage.isEmpty) {
      throw const AuthValidationException(
        'authFailure.message',
        'Must not be empty.',
      );
    }
    return AuthFailure(code: normalizedCode, message: normalizedMessage);
  }

  final String code;
  final String message;

  @override
  bool operator ==(Object other) {
    return other is AuthFailure &&
        other.code == code &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(code, message);
}
