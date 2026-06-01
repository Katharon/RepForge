import '../exceptions/purchase_validation_exception.dart';
import '../value_objects/purchase_product_id.dart';

enum PurchaseProductType { subscription, nonConsumable, consumable, unknown }

final class PurchaseProduct {
  PurchaseProduct({
    required this.id,
    required this.type,
    required String title,
    required String description,
    required String priceLabel,
  }) : title = _requireNonBlank('purchaseProduct.title', title),
       description = _requireNonBlank(
         'purchaseProduct.description',
         description,
       ),
       priceLabel = _requireNonBlank('purchaseProduct.priceLabel', priceLabel);

  final PurchaseProductId id;
  final PurchaseProductType type;
  final String title;
  final String description;
  final String priceLabel;

  @override
  bool operator ==(Object other) {
    return other is PurchaseProduct &&
        other.id == id &&
        other.type == type &&
        other.title == title &&
        other.description == description &&
        other.priceLabel == priceLabel;
  }

  @override
  int get hashCode => Object.hash(id, type, title, description, priceLabel);
}

String _requireNonBlank(String field, String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw PurchaseValidationException(field, 'Must not be empty.');
  }
  return normalized;
}
