enum FirebaseCapability {
  auth,
  remotePush,
  crashReporting,
  remoteConfig,
  analyticsEvents,
}

final class FirebaseCapabilitySet {
  const FirebaseCapabilitySet._(this._values);

  factory FirebaseCapabilitySet.of(Iterable<FirebaseCapability> values) {
    return FirebaseCapabilitySet._(
      Set<FirebaseCapability>.unmodifiable(values),
    );
  }

  factory FirebaseCapabilitySet.only(FirebaseCapability capability) {
    return FirebaseCapabilitySet.of(<FirebaseCapability>{capability});
  }

  static const FirebaseCapabilitySet none = FirebaseCapabilitySet._(
    <FirebaseCapability>{},
  );

  static const FirebaseCapabilitySet localMvp = FirebaseCapabilitySet._(
    <FirebaseCapability>{},
  );

  static const FirebaseCapabilitySet futureFirebaseBoundary =
      FirebaseCapabilitySet._(<FirebaseCapability>{
        FirebaseCapability.auth,
        FirebaseCapability.remotePush,
        FirebaseCapability.crashReporting,
        FirebaseCapability.remoteConfig,
        FirebaseCapability.analyticsEvents,
      });

  final Set<FirebaseCapability> _values;

  bool get isEmpty => _values.isEmpty;

  bool get isNotEmpty => _values.isNotEmpty;

  bool contains(FirebaseCapability capability) => _values.contains(capability);

  Set<FirebaseCapability> toSet() {
    return Set<FirebaseCapability>.unmodifiable(_values);
  }

  @override
  bool operator ==(Object other) {
    if (other is! FirebaseCapabilitySet) {
      return false;
    }
    return _values.length == other._values.length &&
        _values.every(other._values.contains);
  }

  @override
  int get hashCode {
    return Object.hashAll(FirebaseCapability.values.where(_values.contains));
  }
}
