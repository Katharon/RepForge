final class FirebaseInitializationFailure {
  const FirebaseInitializationFailure({
    required this.code,
    required this.message,
  }) : assert(code.length > 0),
       assert(message.length > 0);

  final String code;
  final String message;

  @override
  bool operator ==(Object other) {
    return other is FirebaseInitializationFailure &&
        other.code == code &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(code, message);
}
