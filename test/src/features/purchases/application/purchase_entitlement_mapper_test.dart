import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/entitlements/application/entitlements_application.dart';
import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';
import 'package:repforge/src/features/purchases/application/purchases_application.dart';
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

void main() {
  group('PurchaseEntitlementMapper', () {
    final now = DateTime.utc(2026, 6);
    const mapper = PurchaseEntitlementMapper();
    const policy = EntitlementPolicy();

    test('successful purchase maps to provisional unverified entitlement', () {
      final snapshot = mapper.mapEvent(
        PurchaseEvent(
          productId: PurchaseProductId.repforgePremium,
          status: PurchaseStatus.purchased,
          occurredAt: now,
        ),
      );
      final entitlement = snapshot.stateFor(EntitlementId.repforgePremium);

      expect(entitlement, isNotNull);
      expect(entitlement?.status, EntitlementStatus.active);
      expect(
        entitlement?.source,
        EntitlementSource.appStore(isVerified: false),
      );
      expect(entitlement?.lastVerifiedAt, isNull);

      final decision = policy.decide(
        gate: FeatureGate.coachRecommendations,
        snapshot: snapshot,
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.unknownUnverified);
      expect(decision.reason, FeatureGateDecisionReason.unverifiedEntitlement);
    });

    test('pending purchase maps to explicit unknown entitlement state', () {
      final snapshot = mapper.mapEvent(
        PurchaseEvent(
          productId: PurchaseProductId.repforgePremium,
          status: PurchaseStatus.pending,
          occurredAt: now,
        ),
      );
      final entitlement = snapshot.stateFor(EntitlementId.repforgePremium);

      expect(entitlement?.status, EntitlementStatus.unknown);

      final decision = policy.decide(
        gate: FeatureGate.advancedAnalytics,
        snapshot: snapshot,
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.unknownUnverified);
      expect(decision.reason, FeatureGateDecisionReason.unknownEntitlement);
    });

    test('cancelled failed and unknown purchases do not unlock Premium', () {
      for (final status in <PurchaseStatus>[
        PurchaseStatus.cancelled,
        PurchaseStatus.failed,
        PurchaseStatus.unknown,
      ]) {
        final snapshot = mapper.mapEvent(
          PurchaseEvent(
            productId: PurchaseProductId.repforgePremium,
            status: status,
            occurredAt: now,
          ),
        );

        final decision = policy.decide(
          gate: FeatureGate.muscleBalanceHeatmap,
          snapshot: snapshot,
          evaluatedAt: now,
        );

        expect(snapshot.entitlements, isEmpty);
        expect(decision.outcome, FeatureGateDecisionOutcome.locked);
        expect(decision.reason, FeatureGateDecisionReason.missingEntitlement);
      }
    });

    test('local MVP gates remain allowed without purchase', () {
      final snapshot = EntitlementSnapshot.empty(capturedAt: now);

      for (final gate in FeatureGate.localMvpFeatures) {
        final decision = policy.decide(
          gate: gate,
          snapshot: snapshot,
          evaluatedAt: now,
        );

        expect(decision.outcome, FeatureGateDecisionOutcome.allowed);
      }
    });
  });
}
