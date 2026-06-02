import '../entities/sync_metadata.dart';

enum SyncConflictResolutionKind {
  noConflict,
  useLocal,
  useIncoming,
  manualReview,
}

final class SyncConflictResolution {
  const SyncConflictResolution._({required this.kind, this.resolvedMetadata});

  const SyncConflictResolution.noConflict(SyncMetadata metadata)
    : this._(
        kind: SyncConflictResolutionKind.noConflict,
        resolvedMetadata: metadata,
      );

  const SyncConflictResolution.useLocal(SyncMetadata metadata)
    : this._(
        kind: SyncConflictResolutionKind.useLocal,
        resolvedMetadata: metadata,
      );

  const SyncConflictResolution.useIncoming(SyncMetadata metadata)
    : this._(
        kind: SyncConflictResolutionKind.useIncoming,
        resolvedMetadata: metadata,
      );

  const SyncConflictResolution.manualReview()
    : this._(kind: SyncConflictResolutionKind.manualReview);

  final SyncConflictResolutionKind kind;
  final SyncMetadata? resolvedMetadata;

  @override
  bool operator ==(Object other) {
    return other is SyncConflictResolution &&
        other.kind == kind &&
        other.resolvedMetadata == resolvedMetadata;
  }

  @override
  int get hashCode => Object.hash(kind, resolvedMetadata);
}

final class SyncConflictPolicy {
  const SyncConflictPolicy();

  SyncConflictResolution resolve({
    required SyncMetadata localMetadata,
    required SyncMetadata incomingMetadata,
  }) {
    if (localMetadata.entityType != incomingMetadata.entityType ||
        localMetadata.entityId != incomingMetadata.entityId) {
      return const SyncConflictResolution.manualReview();
    }

    if (localMetadata.deletedAt != null || incomingMetadata.deletedAt != null) {
      return const SyncConflictResolution.manualReview();
    }

    final versionComparison = localMetadata.localVersion.compareTo(
      incomingMetadata.localVersion,
    );
    if (versionComparison > 0) {
      return SyncConflictResolution.useLocal(localMetadata);
    }
    if (versionComparison < 0) {
      return SyncConflictResolution.useIncoming(incomingMetadata);
    }

    if (localMetadata.updatedAt == incomingMetadata.updatedAt) {
      return SyncConflictResolution.noConflict(localMetadata);
    }

    return const SyncConflictResolution.manualReview();
  }
}
