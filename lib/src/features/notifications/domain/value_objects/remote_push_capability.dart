enum RemotePushCapability {
  accountSecurity,
  syncConflictNotice,
  socialActivity,
  serverNews,
  remoteCoachMessage,
}

final class RemotePushCapabilitySet {
  const RemotePushCapabilitySet._(this._values);

  factory RemotePushCapabilitySet.of(Iterable<RemotePushCapability> values) {
    return RemotePushCapabilitySet._(
      Set<RemotePushCapability>.unmodifiable(values),
    );
  }

  factory RemotePushCapabilitySet.only(RemotePushCapability capability) {
    return RemotePushCapabilitySet.of(<RemotePushCapability>{capability});
  }

  static const RemotePushCapabilitySet none = RemotePushCapabilitySet._(
    <RemotePushCapability>{},
  );

  static const RemotePushCapabilitySet localMvp = RemotePushCapabilitySet._(
    <RemotePushCapability>{},
  );

  static const RemotePushCapabilitySet futureBoundary =
      RemotePushCapabilitySet._(<RemotePushCapability>{
        RemotePushCapability.accountSecurity,
        RemotePushCapability.syncConflictNotice,
        RemotePushCapability.socialActivity,
        RemotePushCapability.serverNews,
        RemotePushCapability.remoteCoachMessage,
      });

  final Set<RemotePushCapability> _values;

  bool get isEmpty => _values.isEmpty;

  bool get isNotEmpty => _values.isNotEmpty;

  bool contains(RemotePushCapability capability) =>
      _values.contains(capability);

  Set<RemotePushCapability> toSet() {
    return Set<RemotePushCapability>.unmodifiable(_values);
  }

  @override
  bool operator ==(Object other) {
    if (other is! RemotePushCapabilitySet) {
      return false;
    }
    return _values.length == other._values.length &&
        _values.every(other._values.contains);
  }

  @override
  int get hashCode {
    return Object.hashAll(RemotePushCapability.values.where(_values.contains));
  }
}
