import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

final class RestorePurchases {
  const RestorePurchases(this._gateway);

  final PurchaseGateway _gateway;

  Future<void> call() {
    return _gateway.restorePurchases();
  }
}
