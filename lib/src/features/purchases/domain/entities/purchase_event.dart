import '../value_objects/purchase_error.dart';
import '../value_objects/purchase_product_id.dart';

enum PurchaseStatus { pending, purchased, restored, cancelled, failed, unknown }

final class PurchaseEvent {
  const PurchaseEvent({
    required this.productId,
    required this.status,
    required this.occurredAt,
    this.error,
  });

  final PurchaseProductId productId;
  final PurchaseStatus status;
  final DateTime occurredAt;
  final PurchaseError? error;

  @override
  bool operator ==(Object other) {
    return other is PurchaseEvent &&
        other.productId == productId &&
        other.status == status &&
        other.occurredAt == occurredAt &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(productId, status, occurredAt, error);
}
