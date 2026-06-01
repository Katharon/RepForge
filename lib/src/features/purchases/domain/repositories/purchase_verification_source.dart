import '../entities/purchase_verification_request.dart';
import '../entities/purchase_verification_result.dart';

abstract interface class PurchaseVerificationSource {
  Future<PurchaseVerificationResult> verify(
    PurchaseVerificationRequest request,
  );
}
