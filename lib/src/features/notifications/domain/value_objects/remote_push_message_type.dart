enum RemotePushMessageType {
  accountSecurityNotice,
  syncConflictNotice,
  socialActivity,
  serverNews,
  remoteCoachMessage,
}

final class RemotePushMessageTypeSet {
  const RemotePushMessageTypeSet._(this._values);

  factory RemotePushMessageTypeSet.of(Iterable<RemotePushMessageType> values) {
    return RemotePushMessageTypeSet._(
      Set<RemotePushMessageType>.unmodifiable(values),
    );
  }

  factory RemotePushMessageTypeSet.only(RemotePushMessageType messageType) {
    return RemotePushMessageTypeSet.of(<RemotePushMessageType>{messageType});
  }

  static const RemotePushMessageTypeSet none = RemotePushMessageTypeSet._(
    <RemotePushMessageType>{},
  );

  static const RemotePushMessageTypeSet futureBoundary =
      RemotePushMessageTypeSet._(<RemotePushMessageType>{
        RemotePushMessageType.accountSecurityNotice,
        RemotePushMessageType.syncConflictNotice,
        RemotePushMessageType.socialActivity,
        RemotePushMessageType.serverNews,
        RemotePushMessageType.remoteCoachMessage,
      });

  final Set<RemotePushMessageType> _values;

  bool get isEmpty => _values.isEmpty;

  bool get isNotEmpty => _values.isNotEmpty;

  bool contains(RemotePushMessageType messageType) {
    return _values.contains(messageType);
  }

  Set<RemotePushMessageType> toSet() {
    return Set<RemotePushMessageType>.unmodifiable(_values);
  }

  @override
  bool operator ==(Object other) {
    if (other is! RemotePushMessageTypeSet) {
      return false;
    }
    return _values.length == other._values.length &&
        _values.every(other._values.contains);
  }

  @override
  int get hashCode {
    return Object.hashAll(RemotePushMessageType.values.where(_values.contains));
  }
}
