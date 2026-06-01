import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';

final class PurchaseEntitlementMapper {
  const PurchaseEntitlementMapper();

  EntitlementSnapshot mapEvent(PurchaseEvent event) {
    final status = _entitlementStatusFor(event.status);
    if (status == null) {
      return EntitlementSnapshot.empty(capturedAt: event.occurredAt.toUtc());
    }

    return EntitlementSnapshot(
      capturedAt: event.occurredAt.toUtc(),
      entitlements: <EntitlementState>[
        EntitlementState(
          id: EntitlementId.repforgePremium,
          kind: EntitlementKind.premium,
          status: status,
          source: const EntitlementSource.appStore(isVerified: false),
        ),
      ],
    );
  }
}

EntitlementStatus? _entitlementStatusFor(PurchaseStatus status) {
  switch (status) {
    case PurchaseStatus.purchased:
    case PurchaseStatus.restored:
      return EntitlementStatus.active;
    case PurchaseStatus.pending:
      return EntitlementStatus.unknown;
    case PurchaseStatus.cancelled:
    case PurchaseStatus.failed:
    case PurchaseStatus.unknown:
      return null;
  }
}
