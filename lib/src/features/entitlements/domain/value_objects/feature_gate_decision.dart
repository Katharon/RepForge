import 'feature_gate.dart';

enum FeatureGateDecisionOutcome {
  allowed,
  locked,
  unavailable,
  unknownUnverified,
}

enum FeatureGateDecisionReason {
  freeLocalMvpFeature('free_local_mvp_feature'),
  validEntitlement('valid_entitlement'),
  missingEntitlement('missing_entitlement'),
  expiredEntitlement('expired_entitlement'),
  revokedEntitlement('revoked_entitlement'),
  unavailableEntitlement('unavailable_entitlement'),
  unknownEntitlement('unknown_entitlement'),
  unverifiedEntitlement('unverified_entitlement'),
  futureFeatureUnavailable('future_feature_unavailable');

  const FeatureGateDecisionReason(this.code);

  final String code;
}

final class FeatureGateDecision {
  const FeatureGateDecision({
    required this.gate,
    required this.outcome,
    required this.reason,
  });

  final FeatureGate gate;
  final FeatureGateDecisionOutcome outcome;
  final FeatureGateDecisionReason reason;

  String get reasonCode => reason.code;

  bool get isAllowed => outcome == FeatureGateDecisionOutcome.allowed;

  @override
  bool operator ==(Object other) {
    return other is FeatureGateDecision &&
        other.gate == gate &&
        other.outcome == outcome &&
        other.reason == reason;
  }

  @override
  int get hashCode => Object.hash(gate, outcome, reason);
}
