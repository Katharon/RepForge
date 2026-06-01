import '../value_objects/purchase_product_id.dart';
import 'purchase_event.dart';

final class PurchaseVerificationRequest {
  const PurchaseVerificationRequest({
    required this.productId,
    required this.purchaseStatus,
    required this.requestedAt,
  });

  factory PurchaseVerificationRequest.fromEvent(
    PurchaseEvent event, {
    required DateTime requestedAt,
  }) {
    return PurchaseVerificationRequest(
      productId: event.productId,
      purchaseStatus: event.status,
      requestedAt: requestedAt.toUtc(),
    );
  }

  final PurchaseProductId productId;
  final PurchaseStatus purchaseStatus;
  final DateTime requestedAt;

  @override
  bool operator ==(Object other) {
    return other is PurchaseVerificationRequest &&
        other.productId == productId &&
        other.purchaseStatus == purchaseStatus &&
        other.requestedAt == requestedAt;
  }

  @override
  int get hashCode => Object.hash(productId, purchaseStatus, requestedAt);
}
