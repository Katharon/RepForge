import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

final class StartPurchase {
  const StartPurchase(this._gateway);

  final PurchaseGateway _gateway;

  Future<void> call(PurchaseProduct product) {
    return _gateway.buy(product);
  }
}
