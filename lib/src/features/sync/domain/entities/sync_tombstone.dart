import '../value_objects/sync_entity_id.dart';
import '../value_objects/sync_entity_type.dart';
import '../value_objects/sync_state.dart';
import '../value_objects/sync_version.dart';
import 'sync_metadata.dart';

final class SyncTombstone {
  const SyncTombstone({
    required this.entityType,
    required this.entityId,
    required this.deletedAt,
    required this.localVersion,
  });

  factory SyncTombstone.fromMetadata(SyncMetadata metadata) {
    final deletedAt = metadata.deletedAt;
    if (metadata.syncState != SyncState.tombstoned || deletedAt == null) {
      throw ArgumentError.value(
        metadata,
        'metadata',
        'Metadata must be tombstoned.',
      );
    }
    return SyncTombstone(
      entityType: metadata.entityType,
      entityId: metadata.entityId,
      deletedAt: deletedAt,
      localVersion: metadata.localVersion,
    );
  }

  final SyncEntityType entityType;
  final SyncEntityId entityId;
  final DateTime deletedAt;
  final SyncVersion localVersion;

  @override
  bool operator ==(Object other) {
    return other is SyncTombstone &&
        other.entityType == entityType &&
        other.entityId == entityId &&
        other.deletedAt == deletedAt &&
        other.localVersion == localVersion;
  }

  @override
  int get hashCode =>
      Object.hash(entityType, entityId, deletedAt, localVersion);
}
