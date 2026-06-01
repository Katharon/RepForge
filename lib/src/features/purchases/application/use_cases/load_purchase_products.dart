import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

final class LoadPurchaseProducts {
  const LoadPurchaseProducts(this._gateway);

  final PurchaseGateway _gateway;

  Future<List<PurchaseProduct>> call(Set<PurchaseProductId> productIds) {
    return _gateway.loadProducts(productIds);
  }
}
