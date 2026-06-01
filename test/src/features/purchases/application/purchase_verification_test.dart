import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/entitlements/application/entitlements_application.dart';
import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';
import 'package:repforge/src/features/purchases/application/purchases_application.dart';
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

void main() {
  group('VerifyPurchaseEntitlement', () {
    final now = DateTime.utc(2026, 6);
    const policy = EntitlementPolicy();

    test('unverified provisional purchase does not unlock Premium', () {
      const mapper = PurchaseEntitlementMapper();
      final provisional = mapper.mapEvent(
        PurchaseEvent(
          productId: PurchaseProductId.repforgePremium,
          status: PurchaseStatus.purchased,
          occurredAt: now,
        ),
      );

      final decision = policy.decide(
        gate: FeatureGate.coachRecommendations,
        snapshot: provisional,
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.unknownUnverified);
      expect(decision.reason, FeatureGateDecisionReason.unverifiedEntitlement);
    });

    test(
      'verified purchase unlocks only prepared future Premium gate',
      () async {
        final source = _FakePurchaseVerificationSource(
          PurchaseVerificationResult(
            productId: PurchaseProductId.repforgePremium,
            status: PurchaseVerificationStatus.verified,
            sourceKind: PurchaseVerificationSourceKind.localTest,
            verifiedAt: now,
            expiresAt: now.add(const Duration(days: 7)),
          ),
        );
        final useCase = VerifyPurchaseEntitlement(source, now: () => now);

        final snapshot = await useCase(
          PurchaseEvent(
            productId: PurchaseProductId.repforgePremium,
            status: PurchaseStatus.purchased,
            occurredAt: now,
          ),
        );

        final premiumDecision = policy.decide(
          gate: FeatureGate.advancedAnalytics,
          snapshot: snapshot,
          evaluatedAt: now,
        );
        final unavailableDecision = policy.decide(
          gate: FeatureGate.optionalCloudSync,
          snapshot: snapshot,
          evaluatedAt: now,
        );

        expect(source.verifyCount, 1);
        expect(premiumDecision.outcome, FeatureGateDecisionOutcome.allowed);
        expect(
          premiumDecision.reason,
          FeatureGateDecisionReason.validEntitlement,
        );
        expect(
          unavailableDecision.outcome,
          FeatureGateDecisionOutcome.unavailable,
        );
        expect(
          unavailableDecision.reason,
          FeatureGateDecisionReason.futureFeatureUnavailable,
        );
      },
    );

    test('verified non-Premium product does not unlock Premium', () async {
      final otherProductId = PurchaseProductId('other_product');
      final snapshot =
          await VerifyPurchaseEntitlement(
            _FakePurchaseVerificationSource(
              PurchaseVerificationResult(
                productId: otherProductId,
                status: PurchaseVerificationStatus.verified,
                sourceKind: PurchaseVerificationSourceKind.localTest,
                verifiedAt: now,
              ),
            ),
            now: () => now,
          )(
            PurchaseEvent(
              productId: otherProductId,
              status: PurchaseStatus.purchased,
              occurredAt: now,
            ),
          );

      final decision = policy.decide(
        gate: FeatureGate.coachRecommendations,
        snapshot: snapshot,
        evaluatedAt: now,
      );

      expect(snapshot.entitlements, isEmpty);
      expect(decision.outcome, FeatureGateDecisionOutcome.locked);
      expect(decision.reason, FeatureGateDecisionReason.missingEntitlement);
    });

    test('expired entitlement does not unlock Premium', () async {
      final snapshot =
          await VerifyPurchaseEntitlement(
            _FakePurchaseVerificationSource(
              PurchaseVerificationResult(
                productId: PurchaseProductId.repforgePremium,
                status: PurchaseVerificationStatus.expired,
                sourceKind: PurchaseVerificationSourceKind.localTest,
                verifiedAt: now,
                expiresAt: now.subtract(const Duration(seconds: 1)),
              ),
            ),
            now: () => now,
          )(
            PurchaseEvent(
              productId: PurchaseProductId.repforgePremium,
              status: PurchaseStatus.restored,
              occurredAt: now,
            ),
          );

      final decision = policy.decide(
        gate: FeatureGate.muscleBalanceHeatmap,
        snapshot: snapshot,
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.locked);
      expect(decision.reason, FeatureGateDecisionReason.expiredEntitlement);
    });

    test('revoked entitlement does not unlock Premium', () async {
      final snapshot =
          await VerifyPurchaseEntitlement(
            _FakePurchaseVerificationSource(
              PurchaseVerificationResult(
                productId: PurchaseProductId.repforgePremium,
                status: PurchaseVerificationStatus.revoked,
                sourceKind: PurchaseVerificationSourceKind.localTest,
                verifiedAt: now,
              ),
            ),
            now: () => now,
          )(
            PurchaseEvent(
              productId: PurchaseProductId.repforgePremium,
              status: PurchaseStatus.purchased,
              occurredAt: now,
            ),
          );

      final decision = policy.decide(
        gate: FeatureGate.advancedTemplates,
        snapshot: snapshot,
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.locked);
      expect(decision.reason, FeatureGateDecisionReason.revokedEntitlement);
    });

    test('unavailable verification source is conservative', () async {
      final snapshot =
          await VerifyPurchaseEntitlement(
            _FakePurchaseVerificationSource(
              PurchaseVerificationResult(
                productId: PurchaseProductId.repforgePremium,
                status: PurchaseVerificationStatus.unavailable,
                sourceKind: PurchaseVerificationSourceKind.trustedServer,
                verifiedAt: now,
              ),
            ),
            now: () => now,
          )(
            PurchaseEvent(
              productId: PurchaseProductId.repforgePremium,
              status: PurchaseStatus.purchased,
              occurredAt: now,
            ),
          );

      final decision = policy.decide(
        gate: FeatureGate.advancedAnalytics,
        snapshot: snapshot,
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.unavailable);
      expect(decision.reason, FeatureGateDecisionReason.unavailableEntitlement);
    });

    test(
      'pending failed and unverified events do not call verification',
      () async {
        final source = _FakePurchaseVerificationSource(
          PurchaseVerificationResult(
            productId: PurchaseProductId.repforgePremium,
            status: PurchaseVerificationStatus.verified,
            sourceKind: PurchaseVerificationSourceKind.localTest,
            verifiedAt: now,
          ),
        );
        final useCase = VerifyPurchaseEntitlement(source, now: () => now);

        for (final status in <PurchaseStatus>[
          PurchaseStatus.pending,
          PurchaseStatus.failed,
          PurchaseStatus.cancelled,
          PurchaseStatus.unknown,
        ]) {
          final snapshot = await useCase(
            PurchaseEvent(
              productId: PurchaseProductId.repforgePremium,
              status: status,
              occurredAt: now,
            ),
          );

          expect(snapshot.entitlements, isEmpty);
        }

        expect(source.verifyCount, 0);
      },
    );

    test('local MVP gates remain allowed without verification', () async {
      final snapshot =
          await VerifyPurchaseEntitlement(
            _FakePurchaseVerificationSource(
              PurchaseVerificationResult(
                productId: PurchaseProductId.repforgePremium,
                status: PurchaseVerificationStatus.unavailable,
                sourceKind: PurchaseVerificationSourceKind.trustedServer,
                verifiedAt: now,
              ),
            ),
            now: () => now,
          )(
            PurchaseEvent(
              productId: PurchaseProductId.repforgePremium,
              status: PurchaseStatus.pending,
              occurredAt: now,
            ),
          );

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

  group('EntitlementCachePolicy', () {
    final now = DateTime.utc(2026, 6);
    const policy = EntitlementCachePolicy();

    test('stores and returns only fresh verified snapshots', () {
      final entry = policy.createEntry(
        snapshot: _verifiedSnapshot(now),
        cachedAt: now,
      );

      expect(entry, isNotNull);
      expect(
        entry?.statusAt(now.add(const Duration(hours: 5))),
        CacheStatus.fresh,
      );
      expect(
        policy.trustedSnapshotIfFresh(
          entry!,
          evaluatedAt: now.add(const Duration(hours: 5)),
        ),
        isNotNull,
      );
    });

    test('stale cache behavior is explicit and does not unlock silently', () {
      final entry = policy.createEntry(
        snapshot: _verifiedSnapshot(now),
        cachedAt: now,
      )!;
      final evaluatedAt = now.add(const Duration(hours: 7));

      expect(entry.statusAt(evaluatedAt), CacheStatus.stale);
      expect(
        policy.trustedSnapshotIfFresh(entry, evaluatedAt: evaluatedAt),
        isNull,
      );
    });

    test('expired cache entry does not unlock Premium', () {
      final entry = policy.createEntry(
        snapshot: _verifiedSnapshot(now),
        cachedAt: now,
      )!;
      final evaluatedAt = now.add(const Duration(hours: 25));

      expect(entry.statusAt(evaluatedAt), CacheStatus.expired);
      expect(
        policy.trustedSnapshotIfFresh(entry, evaluatedAt: evaluatedAt),
        isNull,
      );
    });

    test('cache alone is not treated as purchase proof', () {
      final unverifiedSnapshot = EntitlementSnapshot(
        capturedAt: now,
        entitlements: <EntitlementState>[
          EntitlementState(
            id: EntitlementId.repforgePremium,
            kind: EntitlementKind.premium,
            status: EntitlementStatus.active,
            source: const EntitlementSource.appStore(isVerified: false),
            lastVerifiedAt: now,
          ),
        ],
      );

      final entry = policy.createEntry(
        snapshot: unverifiedSnapshot,
        cachedAt: now,
      );

      expect(entry, isNull);
    });

    test('offline behavior is deterministic and conservative', () {
      final staleEntry = policy.createEntry(
        snapshot: _verifiedSnapshot(now),
        cachedAt: now,
      )!;
      final fallbackSnapshot = policy.trustedSnapshotIfFresh(
        staleEntry,
        evaluatedAt: now.add(const Duration(hours: 7)),
      );
      final decision = EntitlementPolicy().decide(
        gate: FeatureGate.coachRecommendations,
        snapshot:
            fallbackSnapshot ?? EntitlementSnapshot.empty(capturedAt: now),
        evaluatedAt: now.add(const Duration(hours: 7)),
      );

      expect(fallbackSnapshot, isNull);
      expect(decision.outcome, FeatureGateDecisionOutcome.locked);
      expect(decision.reason, FeatureGateDecisionReason.missingEntitlement);
    });
  });
}

EntitlementSnapshot _verifiedSnapshot(DateTime now) {
  return EntitlementSnapshot(
    capturedAt: now,
    entitlements: <EntitlementState>[
      EntitlementState(
        id: EntitlementId.repforgePremium,
        kind: EntitlementKind.premium,
        status: EntitlementStatus.active,
        source: const EntitlementSource.trustedServer(),
        expiresAt: now.add(const Duration(days: 7)),
        lastVerifiedAt: now,
      ),
    ],
  );
}

final class _FakePurchaseVerificationSource
    implements PurchaseVerificationSource {
  _FakePurchaseVerificationSource(this.result);

  final PurchaseVerificationResult result;
  int verifyCount = 0;

  @override
  Future<PurchaseVerificationResult> verify(
    PurchaseVerificationRequest request,
  ) async {
    verifyCount += 1;
    return result;
  }
}
