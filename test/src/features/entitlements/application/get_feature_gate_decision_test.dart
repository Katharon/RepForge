import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/entitlements/application/entitlements_application.dart';
import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';

void main() {
  test('decision use case needs no store backend account or files', () async {
    final now = DateTime.utc(2026, 6);
    final source = _FakeEntitlementSnapshotSource(
      EntitlementSnapshot.empty(capturedAt: now),
    );
    final useCase = GetFeatureGateDecision(source, now: () => now);

    final freeDecision = await useCase(FeatureGate.localWorkoutTracking);
    final premiumDecision = await useCase(FeatureGate.advancedTemplates);

    expect(source.loadCount, 2);
    expect(freeDecision.outcome, FeatureGateDecisionOutcome.allowed);
    expect(premiumDecision.outcome, FeatureGateDecisionOutcome.locked);
    expect(premiumDecision.reasonCode, 'missing_entitlement');
  });

  test('local free source exposes an empty entitlement snapshot', () async {
    final now = DateTime.utc(2026, 6);
    final source = LocalFreeEntitlementSnapshotSource(now: () => now);

    final snapshot = await source.loadSnapshot();

    expect(snapshot.capturedAt, now);
    expect(snapshot.entitlements, isEmpty);
  });
}

final class _FakeEntitlementSnapshotSource
    implements EntitlementSnapshotSource {
  _FakeEntitlementSnapshotSource(this.snapshot);

  final EntitlementSnapshot snapshot;
  int loadCount = 0;

  @override
  Future<EntitlementSnapshot> loadSnapshot() async {
    loadCount += 1;
    return snapshot;
  }
}
