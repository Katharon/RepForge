import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/entitlements/application/entitlements_application.dart';
import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';

void main() {
  group('EntitlementPolicy', () {
    final now = DateTime.utc(2026, 6);
    const policy = EntitlementPolicy();

    test('default free policy allows local MVP features', () {
      final snapshot = EntitlementSnapshot.empty(capturedAt: now);

      for (final gate in FeatureGate.localMvpFeatures) {
        final decision = policy.decide(
          gate: gate,
          snapshot: snapshot,
          evaluatedAt: now,
        );

        expect(decision.outcome, FeatureGateDecisionOutcome.allowed);
        expect(decision.reason, FeatureGateDecisionReason.freeLocalMvpFeature);
      }
    });

    test('future premium feature is locked without entitlement', () {
      final decision = policy.decide(
        gate: FeatureGate.coachRecommendations,
        snapshot: EntitlementSnapshot.empty(capturedAt: now),
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.locked);
      expect(decision.reason, FeatureGateDecisionReason.missingEntitlement);
      expect(decision.reasonCode, 'missing_entitlement');
    });

    test('future premium feature is allowed with valid entitlement', () {
      final decision = policy.decide(
        gate: FeatureGate.coachRecommendations,
        snapshot: EntitlementSnapshot(
          capturedAt: now,
          entitlements: <EntitlementState>[
            EntitlementState(
              id: EntitlementId.repforgePremium,
              kind: EntitlementKind.premium,
              status: EntitlementStatus.active,
              source: EntitlementSource.localTest(),
              expiresAt: now.add(const Duration(days: 7)),
              lastVerifiedAt: now,
            ),
          ],
        ),
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.allowed);
      expect(decision.reason, FeatureGateDecisionReason.validEntitlement);
    });

    test('unknown and unverified states do not unlock premium features', () {
      final unknownDecision = policy.decide(
        gate: FeatureGate.advancedAnalytics,
        snapshot: EntitlementSnapshot(
          capturedAt: now,
          entitlements: <EntitlementState>[
            EntitlementState(
              id: EntitlementId.repforgePremium,
              kind: EntitlementKind.premium,
              status: EntitlementStatus.unknown,
              source: EntitlementSource.localDefault(),
            ),
          ],
        ),
        evaluatedAt: now,
      );
      final unverifiedDecision = policy.decide(
        gate: FeatureGate.advancedAnalytics,
        snapshot: EntitlementSnapshot(
          capturedAt: now,
          entitlements: <EntitlementState>[
            EntitlementState(
              id: EntitlementId.repforgePremium,
              kind: EntitlementKind.premium,
              status: EntitlementStatus.active,
              source: EntitlementSource.localDefault(),
            ),
          ],
        ),
        evaluatedAt: now,
      );

      expect(
        unknownDecision.outcome,
        FeatureGateDecisionOutcome.unknownUnverified,
      );
      expect(
        unknownDecision.reason,
        FeatureGateDecisionReason.unknownEntitlement,
      );
      expect(
        unverifiedDecision.outcome,
        FeatureGateDecisionOutcome.unknownUnverified,
      );
      expect(
        unverifiedDecision.reason,
        FeatureGateDecisionReason.unverifiedEntitlement,
      );
    });

    test('expired entitlement does not unlock premium features', () {
      final decision = policy.decide(
        gate: FeatureGate.muscleBalanceHeatmap,
        snapshot: EntitlementSnapshot(
          capturedAt: now,
          entitlements: <EntitlementState>[
            EntitlementState(
              id: EntitlementId.repforgePremium,
              kind: EntitlementKind.premium,
              status: EntitlementStatus.active,
              source: EntitlementSource.localTest(),
              expiresAt: now.subtract(const Duration(seconds: 1)),
              lastVerifiedAt: now.subtract(const Duration(days: 1)),
            ),
          ],
        ),
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.locked);
      expect(decision.reason, FeatureGateDecisionReason.expiredEntitlement);
      expect(decision.reasonCode, 'expired_entitlement');
    });

    test('unavailable gates return deterministic unavailable decision', () {
      final decision = policy.decide(
        gate: FeatureGate.optionalCloudSync,
        snapshot: EntitlementSnapshot.empty(capturedAt: now),
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.unavailable);
      expect(
        decision.reason,
        FeatureGateDecisionReason.futureFeatureUnavailable,
      );
      expect(decision.reasonCode, 'future_feature_unavailable');
    });
  });
}
