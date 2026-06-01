import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';

import '../services/entitlement_policy.dart';

final class GetFeatureGateDecision {
  GetFeatureGateDecision(
    this._source, {
    this._policy = const EntitlementPolicy(),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final EntitlementSnapshotSource _source;
  final EntitlementPolicy _policy;
  final DateTime Function() _now;

  Future<FeatureGateDecision> call(FeatureGate gate) async {
    final snapshot = await _source.loadSnapshot();
    return _policy.decide(
      gate: gate,
      snapshot: snapshot,
      evaluatedAt: _now().toUtc(),
    );
  }
}
