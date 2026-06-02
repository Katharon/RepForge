final class RemotePushToken {
  RemotePushToken(String value) : value = _normalize(value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is RemotePushToken && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'RemotePushToken(<redacted>)';
}

String _normalize(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    throw ArgumentError.value(value, 'value', 'Remote push token is empty.');
  }
  return trimmed;
}
