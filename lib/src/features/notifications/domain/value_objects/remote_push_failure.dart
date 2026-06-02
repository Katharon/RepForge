final class RemotePushFailure {
  const RemotePushFailure({required this.code, required this.message});

  final String code;
  final String message;

  @override
  bool operator ==(Object other) {
    return other is RemotePushFailure &&
        other.code == code &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(code, message);
}
