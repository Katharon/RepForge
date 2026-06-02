import '../value_objects/sync_entity_id.dart';
import '../value_objects/sync_entity_type.dart';
import '../value_objects/sync_state.dart';
import '../value_objects/sync_version.dart';

final class SyncMetadata {
  SyncMetadata({
    required this.entityType,
    required this.entityId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.localVersion,
    required this.syncState,
    String? remoteId,
    DateTime? deletedAt,
  }) : createdAt = _toUtc(createdAt, 'createdAt'),
       updatedAt = _requireNotBefore(
         _toUtc(updatedAt, 'updatedAt'),
         _toUtc(createdAt, 'createdAt'),
         'updatedAt',
       ),
       deletedAt = deletedAt == null
           ? null
           : _requireNotBefore(
               _toUtc(deletedAt, 'deletedAt'),
               _toUtc(createdAt, 'createdAt'),
               'deletedAt',
             ),
       remoteId = _normalizeRemoteId(remoteId) {
    if (syncState == SyncState.tombstoned && deletedAt == null) {
      throw ArgumentError.value(
        deletedAt,
        'deletedAt',
        'Tombstoned metadata must include deletedAt.',
      );
    }
  }

  factory SyncMetadata.localOnly({
    required SyncEntityType entityType,
    required SyncEntityId entityId,
    required DateTime createdAt,
  }) {
    final capturedAt = _toUtc(createdAt, 'createdAt');
    return SyncMetadata(
      entityType: entityType,
      entityId: entityId,
      createdAt: capturedAt,
      updatedAt: capturedAt,
      localVersion: SyncVersion.initial,
      syncState: SyncState.localOnly,
    );
  }

  final SyncEntityType entityType;
  final SyncEntityId entityId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncVersion localVersion;
  final String? remoteId;
  final SyncState syncState;

  bool get requiresRemoteTransport => syncState.requiresRemoteTransport;

  bool get requiresAccount => requiresRemoteTransport;

  SyncMetadata markDeleted({required DateTime deletedAt}) {
    return copyWith(
      updatedAt: deletedAt,
      deletedAt: deletedAt,
      localVersion: localVersion.next(),
      syncState: SyncState.tombstoned,
    );
  }

  SyncMetadata copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    SyncVersion? localVersion,
    String? remoteId,
    SyncState? syncState,
  }) {
    return SyncMetadata(
      entityType: entityType,
      entityId: entityId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      localVersion: localVersion ?? this.localVersion,
      remoteId: remoteId ?? this.remoteId,
      syncState: syncState ?? this.syncState,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SyncMetadata &&
        other.entityType == entityType &&
        other.entityId == entityId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.localVersion == localVersion &&
        other.remoteId == remoteId &&
        other.syncState == syncState;
  }

  @override
  int get hashCode {
    return Object.hash(
      entityType,
      entityId,
      createdAt,
      updatedAt,
      deletedAt,
      localVersion,
      remoteId,
      syncState,
    );
  }
}

DateTime _toUtc(DateTime value, String name) {
  final utcValue = value.toUtc();
  if (utcValue.microsecond != 0) {
    throw ArgumentError.value(value, name, 'Must not include microseconds.');
  }
  return utcValue;
}

DateTime _requireNotBefore(DateTime value, DateTime lowerBound, String name) {
  if (value.isBefore(lowerBound)) {
    throw ArgumentError.value(value, name, 'Must not be before createdAt.');
  }
  return value;
}

String? _normalizeRemoteId(String? value) {
  if (value == null) {
    return null;
  }
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw ArgumentError.value(value, 'remoteId', 'Must not be empty.');
  }
  return normalized;
}
