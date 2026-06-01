import '../exceptions/purchase_validation_exception.dart';

final class PurchaseProductId {
  const PurchaseProductId._(this.value);

  factory PurchaseProductId(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw const PurchaseValidationException(
        'purchaseProductId',
        'Must not be empty.',
      );
    }
    return PurchaseProductId._(normalized);
  }

  static const repforgePremium = PurchaseProductId._(
    'repforge_premium_placeholder',
  );

  final String value;

  @override
  bool operator ==(Object other) {
    return other is PurchaseProductId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
