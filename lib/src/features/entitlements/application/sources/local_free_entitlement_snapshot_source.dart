import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';

final class LocalFreeEntitlementSnapshotSource
    implements EntitlementSnapshotSource {
  LocalFreeEntitlementSnapshotSource({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  @override
  Future<EntitlementSnapshot> loadSnapshot() async {
    return EntitlementSnapshot.empty(capturedAt: _now().toUtc());
  }
}
