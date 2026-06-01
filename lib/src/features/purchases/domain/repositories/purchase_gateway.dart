import '../entities/purchase_event.dart';
import '../entities/purchase_product.dart';
import '../value_objects/purchase_product_id.dart';

abstract interface class PurchaseGateway {
  Stream<PurchaseEvent> get purchaseEvents;

  Future<bool> isAvailable();

  Future<List<PurchaseProduct>> loadProducts(Set<PurchaseProductId> productIds);

  Future<void> buy(PurchaseProduct product);

  Future<void> restorePurchases();

  Future<void> completePurchase(PurchaseEvent event);
}
