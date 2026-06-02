final class SyncVersion implements Comparable<SyncVersion> {
  const SyncVersion(this.value) : assert(value >= 1);

  static const SyncVersion initial = SyncVersion(1);

  final int value;

  SyncVersion next() {
    return SyncVersion(value + 1);
  }

  @override
  int compareTo(SyncVersion other) => value.compareTo(other.value);

  @override
  bool operator ==(Object other) {
    return other is SyncVersion && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
