import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

import '../fakes/fake_purchase_gateway.dart';

void main() {
  test(
    'available purchase products load through gateway abstraction',
    () async {
      final gateway = FakePurchaseGateway(
        now: () => DateTime.utc(2026, 6),
        products: <PurchaseProduct>[_premiumMonthly],
      );
      addTearDown(gateway.close);

      final products = await gateway.loadProducts({_premiumMonthly.id});

      expect(await gateway.isAvailable(), isTrue);
      expect(products, <PurchaseProduct>[_premiumMonthly]);
      expect(gateway.requestedProducts, <PurchaseProductId>[
        _premiumMonthly.id,
      ]);
    },
  );

  test('fake successful purchase emits deterministic event', () async {
    final now = DateTime.utc(2026, 6);
    final gateway = FakePurchaseGateway(
      now: () => now,
      products: <PurchaseProduct>[_premiumMonthly],
    );
    addTearDown(gateway.close);
    final eventFuture = gateway.purchaseEvents.first;

    await gateway.buy(_premiumMonthly);

    final event = await eventFuture;
    expect(event.productId, _premiumMonthly.id);
    expect(event.status, PurchaseStatus.purchased);
    expect(event.occurredAt, now);
    expect(event.error, isNull);
  });

  test('fake cancelled and failed purchases emit non-success events', () async {
    final now = DateTime.utc(2026, 6);
    final gateway = FakePurchaseGateway(
      now: () => now,
      products: <PurchaseProduct>[_premiumMonthly],
    );
    addTearDown(gateway.close);

    gateway.nextStatus = PurchaseStatus.cancelled;
    final cancelledFuture = gateway.purchaseEvents.first;
    await gateway.buy(_premiumMonthly);
    expect((await cancelledFuture).status, PurchaseStatus.cancelled);

    gateway.nextStatus = PurchaseStatus.failed;
    gateway.nextError = PurchaseError(code: 'store_error', message: 'Failed.');
    final failedFuture = gateway.purchaseEvents.first;
    await gateway.buy(_premiumMonthly);
    final failed = await failedFuture;

    expect(failed.status, PurchaseStatus.failed);
    expect(failed.error?.code, 'store_error');
  });

  test(
    'fake gateway does not require backend account cloud or files',
    () async {
      final gateway = FakePurchaseGateway(
        now: () => DateTime.utc(2026, 6),
        products: <PurchaseProduct>[_premiumMonthly],
      );
      addTearDown(gateway.close);

      await gateway.restorePurchases();

      expect(gateway.restoreCalled, isTrue);
    },
  );
}

final _premiumMonthly = PurchaseProduct(
  id: PurchaseProductId('repforge_premium_monthly'),
  type: PurchaseProductType.subscription,
  title: 'RepForge Premium',
  description: 'Premium coach features',
  priceLabel: 'EUR 4.99',
);
