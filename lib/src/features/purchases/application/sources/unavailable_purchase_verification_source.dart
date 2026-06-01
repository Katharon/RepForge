import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

final class UnavailablePurchaseVerificationSource
    implements PurchaseVerificationSource {
  UnavailablePurchaseVerificationSource({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  @override
  Future<PurchaseVerificationResult> verify(
    PurchaseVerificationRequest request,
  ) async {
    return PurchaseVerificationResult(
      productId: request.productId,
      status: PurchaseVerificationStatus.unavailable,
      sourceKind: PurchaseVerificationSourceKind.trustedServer,
      verifiedAt: _now().toUtc(),
    );
  }
}
