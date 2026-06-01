import '../exceptions/entitlement_validation_exception.dart';
import '../value_objects/entitlement_id.dart';
import '../value_objects/entitlement_state.dart';

final class EntitlementSnapshot {
  EntitlementSnapshot({
    required this.capturedAt,
    Iterable<EntitlementState> entitlements = const <EntitlementState>[],
  }) : entitlements = List<EntitlementState>.unmodifiable(
         _validateEntitlements(entitlements),
       );

  factory EntitlementSnapshot.empty({required DateTime capturedAt}) {
    return EntitlementSnapshot(capturedAt: capturedAt);
  }

  final DateTime capturedAt;
  final List<EntitlementState> entitlements;

  EntitlementState? stateFor(EntitlementId id) {
    for (final entitlement in entitlements) {
      if (entitlement.id == id) {
        return entitlement;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    return other is EntitlementSnapshot &&
        other.capturedAt == capturedAt &&
        _sameEntitlements(other.entitlements, entitlements);
  }

  @override
  int get hashCode => Object.hash(capturedAt, Object.hashAll(entitlements));
}

List<EntitlementState> _validateEntitlements(
  Iterable<EntitlementState> entitlements,
) {
  final normalized = entitlements.toList(growable: false);
  final seen = <EntitlementId>{};
  for (final entitlement in normalized) {
    if (!seen.add(entitlement.id)) {
      throw const EntitlementValidationException(
        'entitlements',
        'Must not contain duplicate entitlement IDs.',
      );
    }
  }
  return normalized;
}

bool _sameEntitlements(List<EntitlementState> a, List<EntitlementState> b) {
  if (a.length != b.length) {
    return false;
  }
  for (var index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) {
      return false;
    }
  }
  return true;
}
