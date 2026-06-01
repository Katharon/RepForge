import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';

final class EntitlementPolicy {
  const EntitlementPolicy();

  FeatureGateDecision decide({
    required FeatureGate gate,
    required EntitlementSnapshot snapshot,
    required DateTime evaluatedAt,
  }) {
    if (gate.isLocalMvpFeature) {
      return FeatureGateDecision(
        gate: gate,
        outcome: FeatureGateDecisionOutcome.allowed,
        reason: FeatureGateDecisionReason.freeLocalMvpFeature,
      );
    }

    if (gate.isUnavailableBeforeFutureSlice) {
      return FeatureGateDecision(
        gate: gate,
        outcome: FeatureGateDecisionOutcome.unavailable,
        reason: FeatureGateDecisionReason.futureFeatureUnavailable,
      );
    }

    final entitlement = snapshot.stateFor(EntitlementId.repforgePremium);
    if (entitlement == null) {
      return FeatureGateDecision(
        gate: gate,
        outcome: FeatureGateDecisionOutcome.locked,
        reason: FeatureGateDecisionReason.missingEntitlement,
      );
    }

    if (entitlement.status == EntitlementStatus.unknown) {
      return FeatureGateDecision(
        gate: gate,
        outcome: FeatureGateDecisionOutcome.unknownUnverified,
        reason: FeatureGateDecisionReason.unknownEntitlement,
      );
    }

    if (!entitlement.source.isVerified) {
      return FeatureGateDecision(
        gate: gate,
        outcome: FeatureGateDecisionOutcome.unknownUnverified,
        reason: FeatureGateDecisionReason.unverifiedEntitlement,
      );
    }

    if (entitlement.isExpiredAt(evaluatedAt)) {
      return FeatureGateDecision(
        gate: gate,
        outcome: FeatureGateDecisionOutcome.locked,
        reason: FeatureGateDecisionReason.expiredEntitlement,
      );
    }

    switch (entitlement.status) {
      case EntitlementStatus.active:
        return FeatureGateDecision(
          gate: gate,
          outcome: FeatureGateDecisionOutcome.allowed,
          reason: FeatureGateDecisionReason.validEntitlement,
        );
      case EntitlementStatus.revoked:
        return FeatureGateDecision(
          gate: gate,
          outcome: FeatureGateDecisionOutcome.locked,
          reason: FeatureGateDecisionReason.revokedEntitlement,
        );
      case EntitlementStatus.unavailable:
        return FeatureGateDecision(
          gate: gate,
          outcome: FeatureGateDecisionOutcome.unavailable,
          reason: FeatureGateDecisionReason.unavailableEntitlement,
        );
      case EntitlementStatus.expired:
        return FeatureGateDecision(
          gate: gate,
          outcome: FeatureGateDecisionOutcome.locked,
          reason: FeatureGateDecisionReason.expiredEntitlement,
        );
      case EntitlementStatus.unknown:
        return FeatureGateDecision(
          gate: gate,
          outcome: FeatureGateDecisionOutcome.unknownUnverified,
          reason: FeatureGateDecisionReason.unknownEntitlement,
        );
    }
  }
}
