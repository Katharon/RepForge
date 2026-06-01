import '../value_objects/purchase_product_id.dart';

enum PurchaseVerificationStatus {
  unverified,
  verified,
  expired,
  revoked,
  stale,
  unavailable,
  failed,
}

enum PurchaseVerificationSourceKind {
  trustedServer,
  appStoreServerApi,
  localTest,
}

final class PurchaseVerificationResult {
  const PurchaseVerificationResult({
    required this.productId,
    required this.status,
    required this.sourceKind,
    required this.verifiedAt,
    this.expiresAt,
  });

  final PurchaseProductId productId;
  final PurchaseVerificationStatus status;
  final PurchaseVerificationSourceKind sourceKind;
  final DateTime verifiedAt;
  final DateTime? expiresAt;

  @override
  bool operator ==(Object other) {
    return other is PurchaseVerificationResult &&
        other.productId == productId &&
        other.status == status &&
        other.sourceKind == sourceKind &&
        other.verifiedAt == verifiedAt &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode =>
      Object.hash(productId, status, sourceKind, verifiedAt, expiresAt);
}
