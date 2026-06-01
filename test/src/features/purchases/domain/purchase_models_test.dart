import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

void main() {
  test('purchase product id trims and rejects blank values', () {
    expect(
      PurchaseProductId(' repforge_premium_monthly ').value,
      'repforge_premium_monthly',
    );
    expect(
      () => PurchaseProductId(' '),
      throwsA(isA<PurchaseValidationException>()),
    );
  });

  test('purchase product exposes deterministic display metadata', () {
    final product = PurchaseProduct(
      id: PurchaseProductId('repforge_premium_monthly'),
      type: PurchaseProductType.subscription,
      title: 'RepForge Premium',
      description: 'Premium coach features',
      priceLabel: 'EUR 4.99',
    );

    expect(product.id.value, 'repforge_premium_monthly');
    expect(product.type, PurchaseProductType.subscription);
    expect(product.title, 'RepForge Premium');
    expect(product.priceLabel, 'EUR 4.99');
  });
}
