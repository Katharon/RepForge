import 'dart:async';

import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

final class FakePurchaseGateway implements PurchaseGateway {
  FakePurchaseGateway({
    required Iterable<PurchaseProduct> products,
    required this.now,
  }) : _products = {for (final product in products) product.id: product};

  final Map<PurchaseProductId, PurchaseProduct> _products;
  final DateTime Function() now;
  final StreamController<PurchaseEvent> _events =
      StreamController<PurchaseEvent>.broadcast();
  final List<PurchaseProductId> requestedProducts = <PurchaseProductId>[];
  PurchaseStatus nextStatus = PurchaseStatus.purchased;
  PurchaseError? nextError;
  bool available = true;
  bool restoreCalled = false;

  @override
  Stream<PurchaseEvent> get purchaseEvents => _events.stream;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<List<PurchaseProduct>> loadProducts(
    Set<PurchaseProductId> productIds,
  ) async {
    requestedProducts.addAll(productIds);
    return productIds
        .map((id) => _products[id])
        .whereType<PurchaseProduct>()
        .toList(growable: false);
  }

  @override
  Future<void> buy(PurchaseProduct product) async {
    if (!available) {
      throw PurchaseGatewayException(
        PurchaseError(
          code: 'store_unavailable',
          message: 'Purchase store is unavailable.',
        ),
      );
    }

    _events.add(
      PurchaseEvent(
        productId: product.id,
        status: nextStatus,
        occurredAt: now(),
        error: nextError,
      ),
    );
  }

  @override
  Future<void> restorePurchases() async {
    restoreCalled = true;
  }

  @override
  Future<void> completePurchase(PurchaseEvent event) async {}

  Future<void> close() => _events.close();
}
