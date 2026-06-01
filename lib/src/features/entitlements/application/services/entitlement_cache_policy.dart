import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';

final class EntitlementCachePolicy {
  const EntitlementCachePolicy({
    this.freshFor = const Duration(hours: 6),
    this.usableFor = const Duration(hours: 24),
  });

  final Duration freshFor;
  final Duration usableFor;

  EntitlementCacheEntry? createEntry({
    required EntitlementSnapshot snapshot,
    required DateTime cachedAt,
  }) {
    if (!_isTrustedVerifiedSnapshot(snapshot)) {
      return null;
    }
    final cachedAtUtc = cachedAt.toUtc();
    return EntitlementCacheEntry(
      snapshot: snapshot,
      cachedAt: cachedAtUtc,
      staleAt: cachedAtUtc.add(freshFor),
      expiresAt: cachedAtUtc.add(usableFor),
    );
  }

  EntitlementSnapshot? trustedSnapshotIfFresh(
    EntitlementCacheEntry entry, {
    required DateTime evaluatedAt,
  }) {
    if (entry.statusAt(evaluatedAt) != CacheStatus.fresh) {
      return null;
    }
    if (!_isTrustedVerifiedSnapshot(entry.snapshot)) {
      return null;
    }
    return entry.snapshot;
  }
}

bool _isTrustedVerifiedSnapshot(EntitlementSnapshot snapshot) {
  if (snapshot.entitlements.isEmpty) {
    return false;
  }
  for (final entitlement in snapshot.entitlements) {
    if (!entitlement.source.isVerified || entitlement.lastVerifiedAt == null) {
      return false;
    }
  }
  return true;
}
