import '../value_objects/purchase_error.dart';

final class PurchaseGatewayException implements Exception {
  const PurchaseGatewayException(this.error);

  final PurchaseError error;

  @override
  String toString() => 'PurchaseGatewayException(${error.code})';
}
