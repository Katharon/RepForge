import '../exceptions/entitlement_validation_exception.dart';

final class EntitlementId {
  const EntitlementId._(this.value);

  factory EntitlementId(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw const EntitlementValidationException(
        'entitlementId',
        'Must not be empty.',
      );
    }
    return EntitlementId._(normalized);
  }

  static const repforgePremium = EntitlementId._('repforge.premium');

  final String value;

  @override
  bool operator ==(Object other) {
    return other is EntitlementId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
