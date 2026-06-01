import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

final class VerifyPurchaseEntitlement {
  VerifyPurchaseEntitlement(this._source, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final PurchaseVerificationSource _source;
  final DateTime Function() _now;

  Future<EntitlementSnapshot> call(PurchaseEvent event) async {
    final capturedAt = _now().toUtc();
    if (!_canVerify(event.status)) {
      return EntitlementSnapshot.empty(capturedAt: capturedAt);
    }

    final result = await _source.verify(
      PurchaseVerificationRequest.fromEvent(event, requestedAt: capturedAt),
    );
    return _snapshotFor(result, capturedAt: capturedAt);
  }
}

bool _canVerify(PurchaseStatus status) {
  return status == PurchaseStatus.purchased ||
      status == PurchaseStatus.restored;
}

EntitlementSnapshot _snapshotFor(
  PurchaseVerificationResult result, {
  required DateTime capturedAt,
}) {
  if (result.productId != PurchaseProductId.repforgePremium) {
    return EntitlementSnapshot.empty(capturedAt: capturedAt);
  }

  final entitlementStatus = _entitlementStatusFor(result.status);
  if (entitlementStatus == null) {
    return EntitlementSnapshot.empty(capturedAt: capturedAt);
  }

  return EntitlementSnapshot(
    capturedAt: capturedAt,
    entitlements: <EntitlementState>[
      EntitlementState(
        id: EntitlementId.repforgePremium,
        kind: EntitlementKind.premium,
        status: entitlementStatus,
        source: _entitlementSourceFor(result.sourceKind),
        expiresAt: result.expiresAt?.toUtc(),
        lastVerifiedAt: result.verifiedAt.toUtc(),
      ),
    ],
  );
}

EntitlementStatus? _entitlementStatusFor(PurchaseVerificationStatus status) {
  switch (status) {
    case PurchaseVerificationStatus.verified:
      return EntitlementStatus.active;
    case PurchaseVerificationStatus.expired:
      return EntitlementStatus.expired;
    case PurchaseVerificationStatus.revoked:
      return EntitlementStatus.revoked;
    case PurchaseVerificationStatus.stale:
      return EntitlementStatus.unknown;
    case PurchaseVerificationStatus.unavailable:
      return EntitlementStatus.unavailable;
    case PurchaseVerificationStatus.unverified:
    case PurchaseVerificationStatus.failed:
      return null;
  }
}

EntitlementSource _entitlementSourceFor(PurchaseVerificationSourceKind source) {
  switch (source) {
    case PurchaseVerificationSourceKind.localTest:
      return const EntitlementSource.localTest();
    case PurchaseVerificationSourceKind.trustedServer:
    case PurchaseVerificationSourceKind.appStoreServerApi:
      return const EntitlementSource.trustedServer();
  }
}
