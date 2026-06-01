import '../exceptions/purchase_validation_exception.dart';

final class PurchaseError {
  PurchaseError({required String code, required String message})
    : code = _requireNonBlank('purchaseError.code', code),
      message = _requireNonBlank('purchaseError.message', message);

  final String code;
  final String message;

  @override
  bool operator ==(Object other) {
    return other is PurchaseError &&
        other.code == code &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(code, message);
}

String _requireNonBlank(String field, String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw PurchaseValidationException(field, 'Must not be empty.');
  }
  return normalized;
}
