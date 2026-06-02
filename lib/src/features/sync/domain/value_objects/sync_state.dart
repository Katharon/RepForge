enum SyncState {
  localOnly,
  pendingUpload,
  synced,
  conflict,
  tombstoned,
  failed,
  unavailable,
}

extension SyncStatePolicy on SyncState {
  bool get requiresRemoteTransport {
    return switch (this) {
      SyncState.pendingUpload ||
      SyncState.synced ||
      SyncState.conflict ||
      SyncState.tombstoned ||
      SyncState.failed => true,
      SyncState.localOnly || SyncState.unavailable => false,
    };
  }
}
