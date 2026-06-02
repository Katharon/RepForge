final class SyncEntityId {
  SyncEntityId(String value) : value = _normalize(value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is SyncEntityId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

String _normalize(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw ArgumentError.value(value, 'value', 'Must not be empty.');
  }
  return normalized;
}
