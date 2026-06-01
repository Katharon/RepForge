import 'entitlement_snapshot.dart';

enum CacheStatus { fresh, stale, expired }

final class EntitlementCacheEntry {
  const EntitlementCacheEntry({
    required this.snapshot,
    required this.cachedAt,
    required this.staleAt,
    required this.expiresAt,
  });

  final EntitlementSnapshot snapshot;
  final DateTime cachedAt;
  final DateTime staleAt;
  final DateTime expiresAt;

  CacheStatus statusAt(DateTime evaluatedAt) {
    final evaluatedAtUtc = evaluatedAt.toUtc();
    if (!_isBefore(evaluatedAtUtc, expiresAt.toUtc())) {
      return CacheStatus.expired;
    }
    if (!_isBefore(evaluatedAtUtc, staleAt.toUtc())) {
      return CacheStatus.stale;
    }
    return CacheStatus.fresh;
  }
}

bool _isBefore(DateTime value, DateTime boundary) {
  return value.isBefore(boundary);
}
