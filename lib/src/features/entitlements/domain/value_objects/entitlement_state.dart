import 'entitlement_id.dart';
import 'entitlement_source.dart';

enum EntitlementKind { premium }

enum EntitlementStatus { active, expired, revoked, unavailable, unknown }

final class EntitlementState {
  const EntitlementState({
    required this.id,
    required this.kind,
    required this.status,
    required this.source,
    this.expiresAt,
    this.lastVerifiedAt,
  });

  final EntitlementId id;
  final EntitlementKind kind;
  final EntitlementStatus status;
  final EntitlementSource source;
  final DateTime? expiresAt;
  final DateTime? lastVerifiedAt;

  bool isExpiredAt(DateTime evaluatedAt) {
    final expiresAt = this.expiresAt;
    if (status == EntitlementStatus.expired) {
      return true;
    }
    if (expiresAt == null) {
      return false;
    }
    final evaluatedAtUtc = evaluatedAt.toUtc();
    final expiresAtUtc = expiresAt.toUtc();
    return expiresAtUtc.isBefore(evaluatedAtUtc) ||
        expiresAtUtc.isAtSameMomentAs(evaluatedAtUtc);
  }

  bool isValidAt(DateTime evaluatedAt) {
    return status == EntitlementStatus.active &&
        source.isVerified &&
        !isExpiredAt(evaluatedAt);
  }

  @override
  bool operator ==(Object other) {
    return other is EntitlementState &&
        other.id == id &&
        other.kind == kind &&
        other.status == status &&
        other.source == source &&
        other.expiresAt == expiresAt &&
        other.lastVerifiedAt == lastVerifiedAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, status, source, expiresAt, lastVerifiedAt);
}
