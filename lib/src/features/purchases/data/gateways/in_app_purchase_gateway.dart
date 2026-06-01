import 'package:in_app_purchase/in_app_purchase.dart' as iap;
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

final class InAppPurchaseGateway implements PurchaseGateway {
  InAppPurchaseGateway({
    iap.InAppPurchase? inAppPurchase,
    Map<PurchaseProductId, PurchaseProductType> productTypes =
        const <PurchaseProductId, PurchaseProductType>{},
    DateTime Function()? now,
  }) : _inAppPurchase = inAppPurchase ?? iap.InAppPurchase.instance,
       _productTypes = Map<PurchaseProductId, PurchaseProductType>.unmodifiable(
         productTypes,
       ),
       _now = now ?? DateTime.now;

  final iap.InAppPurchase _inAppPurchase;
  final Map<PurchaseProductId, PurchaseProductType> _productTypes;
  final DateTime Function() _now;
  final Map<PurchaseProductId, iap.ProductDetails> _cachedProducts =
      <PurchaseProductId, iap.ProductDetails>{};
  final Map<PurchaseProductId, iap.PurchaseDetails> _pendingCompletions =
      <PurchaseProductId, iap.PurchaseDetails>{};

  @override
  Stream<PurchaseEvent> get purchaseEvents {
    return _inAppPurchase.purchaseStream.expand(_mapPurchaseDetails);
  }

  @override
  Future<bool> isAvailable() {
    return _inAppPurchase.isAvailable();
  }

  @override
  Future<List<PurchaseProduct>> loadProducts(
    Set<PurchaseProductId> productIds,
  ) async {
    if (productIds.isEmpty || !await _inAppPurchase.isAvailable()) {
      return const <PurchaseProduct>[];
    }

    final response = await _inAppPurchase.queryProductDetails(
      productIds.map((id) => id.value).toSet(),
    );
    final error = response.error;
    if (error != null) {
      throw PurchaseGatewayException(
        PurchaseError(code: error.code, message: error.message),
      );
    }

    return response.productDetails
        .map(_mapProductDetails)
        .toList(growable: false);
  }

  @override
  Future<void> buy(PurchaseProduct product) async {
    final productDetails = _cachedProducts[product.id];
    if (productDetails == null) {
      throw PurchaseGatewayException(
        PurchaseError(
          code: 'product_not_loaded',
          message: 'Purchase product must be loaded before buying.',
        ),
      );
    }

    final purchaseParam = iap.PurchaseParam(productDetails: productDetails);
    final started = switch (product.type) {
      PurchaseProductType.consumable => await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
      ),
      PurchaseProductType.subscription ||
      PurchaseProductType.nonConsumable ||
      PurchaseProductType.unknown => await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      ),
    };
    if (!started) {
      throw PurchaseGatewayException(
        PurchaseError(
          code: 'purchase_not_started',
          message: 'Store did not start the purchase flow.',
        ),
      );
    }
  }

  @override
  Future<void> restorePurchases() {
    return _inAppPurchase.restorePurchases();
  }

  @override
  Future<void> completePurchase(PurchaseEvent event) async {
    final details = _pendingCompletions.remove(event.productId);
    if (details == null || !details.pendingCompletePurchase) {
      return;
    }
    await _inAppPurchase.completePurchase(details);
  }

  PurchaseProduct _mapProductDetails(iap.ProductDetails details) {
    final id = PurchaseProductId(details.id);
    _cachedProducts[id] = details;
    return PurchaseProduct(
      id: id,
      type: _productTypes[id] ?? PurchaseProductType.unknown,
      title: details.title,
      description: details.description,
      priceLabel: details.price,
    );
  }

  Iterable<PurchaseEvent> _mapPurchaseDetails(
    List<iap.PurchaseDetails> details,
  ) {
    return details.map((detail) {
      final productId = PurchaseProductId(detail.productID);
      if (detail.pendingCompletePurchase) {
        _pendingCompletions[productId] = detail;
      }

      final error = detail.error == null
          ? null
          : PurchaseError(
              code: detail.error!.code,
              message: detail.error!.message,
            );
      return PurchaseEvent(
        productId: productId,
        status: _mapStatus(detail.status),
        occurredAt: _now().toUtc(),
        error: error,
      );
    });
  }
}

PurchaseStatus _mapStatus(iap.PurchaseStatus status) {
  switch (status) {
    case iap.PurchaseStatus.pending:
      return PurchaseStatus.pending;
    case iap.PurchaseStatus.purchased:
      return PurchaseStatus.purchased;
    case iap.PurchaseStatus.restored:
      return PurchaseStatus.restored;
    case iap.PurchaseStatus.error:
      return PurchaseStatus.failed;
    case iap.PurchaseStatus.canceled:
      return PurchaseStatus.cancelled;
  }
}
