import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/auth/application/auth_application.dart';
import 'package:repforge/src/features/auth/domain/auth_domain.dart';
import 'package:repforge/src/features/entitlements/application/entitlements_application.dart';
import 'package:repforge/src/features/entitlements/domain/entitlements_domain.dart';
import 'package:repforge/src/features/purchases/application/purchases_application.dart';
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';
import 'package:repforge/src/features/settings/application/settings_application.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

import '../fakes/fake_auth_gateway.dart';

void main() {
  group('auth boundary', () {
    final now = DateTime.utc(2026, 6);
    const policy = AuthSessionPolicy();

    test('default auth state is localOnly and non-blocking', () async {
      final gateway = LocalOnlyAuthGateway(now: () => now);
      final status = await GetAuthStatus(gateway)();

      expect(status.session.state, AuthSessionState.localOnly);
      expect(status.session.identity, isNull);
      expect(policy.allowsLocalUse(status), isTrue);
    });

    test(
      'authenticated fake session is represented deterministically',
      () async {
        final identity = AuthIdentity(
          userId: AuthUserId('user-1'),
          provider: AuthProvider.localTest,
          displayName: 'Local Test User',
        );
        final gateway = FakeAuthGateway(
          AuthStatusSnapshot(
            capturedAt: now,
            session: AuthSession.authenticated(
              identity: identity,
              authenticatedAt: now,
              expiresAt: now.add(const Duration(hours: 1)),
            ),
          ),
        );

        final status = await GetAuthStatus(gateway)();

        expect(status.session.state, AuthSessionState.authenticated);
        expect(status.session.identity, identity);
        expect(status.session.isAuthenticatedAt(now), isTrue);
        expect(policy.allowsLocalUse(status), isTrue);
      },
    );

    test('expired session is represented deterministically', () async {
      final gateway = FakeAuthGateway(
        AuthStatusSnapshot(
          capturedAt: now,
          session: AuthSession.expired(
            identity: AuthIdentity(
              userId: AuthUserId('expired-user'),
              provider: AuthProvider.localTest,
            ),
            authenticatedAt: now.subtract(const Duration(hours: 2)),
            expiredAt: now.subtract(const Duration(minutes: 1)),
          ),
        ),
      );

      final status = await GetAuthStatus(gateway)();

      expect(status.session.state, AuthSessionState.expired);
      expect(status.session.isAuthenticatedAt(now), isFalse);
      expect(policy.allowsLocalUse(status), isTrue);
    });

    test('unavailable and failed auth states do not block local use', () {
      for (final session in <AuthSession>[
        const AuthSession.unavailable(),
        const AuthSession.failed(
          AuthFailure(code: 'provider_unavailable', message: 'Unavailable.'),
        ),
      ]) {
        final status = AuthStatusSnapshot(capturedAt: now, session: session);

        expect(policy.allowsLocalUse(status), isTrue);
        expect(policy.requiresAccountForLocalUse(status), isFalse);
      }
    });

    test(
      'sign-out clears only auth state and not local settings data',
      () async {
        final profile = SettingsProfile.defaults().copyWith(
          focusProfile: FocusProfile.timeEfficient,
        );
        final settingsRepository = _FakeSettingsProfileRepository(profile);
        final authGateway = FakeAuthGateway(
          AuthStatusSnapshot(
            capturedAt: now,
            session: AuthSession.authenticated(
              identity: AuthIdentity(
                userId: AuthUserId('user-1'),
                provider: AuthProvider.localTest,
              ),
              authenticatedAt: now,
            ),
          ),
        );

        final signedOut = await SignOut(authGateway)();

        expect(signedOut.session.state, AuthSessionState.signedOut);
        expect(await LoadSettingsProfile(settingsRepository)(), profile);
        expect(settingsRepository.saveCount, 0);
      },
    );

    test('auth state does not unlock Premium gates', () async {
      final authGateway = FakeAuthGateway(
        AuthStatusSnapshot(
          capturedAt: now,
          session: AuthSession.authenticated(
            identity: AuthIdentity(
              userId: AuthUserId('premium-looking-user'),
              provider: AuthProvider.localTest,
            ),
            authenticatedAt: now,
          ),
        ),
      );

      await GetAuthStatus(authGateway)();
      final decision = const EntitlementPolicy().decide(
        gate: FeatureGate.coachRecommendations,
        snapshot: EntitlementSnapshot.empty(capturedAt: now),
        evaluatedAt: now,
      );

      expect(decision.outcome, FeatureGateDecisionOutcome.locked);
      expect(decision.reason, FeatureGateDecisionReason.missingEntitlement);
    });

    test('purchase verification does not require auth', () async {
      final verifier = VerifyPurchaseEntitlement(
        _FakePurchaseVerificationSource(
          PurchaseVerificationResult(
            productId: PurchaseProductId.repforgePremium,
            status: PurchaseVerificationStatus.verified,
            sourceKind: PurchaseVerificationSourceKind.localTest,
            verifiedAt: now,
          ),
        ),
        now: () => now,
      );

      final snapshot = await verifier(
        PurchaseEvent(
          productId: PurchaseProductId.repforgePremium,
          status: PurchaseStatus.purchased,
          occurredAt: now,
        ),
      );

      expect(
        snapshot.stateFor(EntitlementId.repforgePremium)?.status,
        EntitlementStatus.active,
      );
    });
  });
}

final class _FakeSettingsProfileRepository
    implements SettingsProfileRepository {
  _FakeSettingsProfileRepository(this.profile);

  SettingsProfile profile;
  int saveCount = 0;

  @override
  Future<SettingsProfile> load() async => profile;

  @override
  Future<void> save(SettingsProfile profile) async {
    saveCount += 1;
    this.profile = profile;
  }
}

final class _FakePurchaseVerificationSource
    implements PurchaseVerificationSource {
  const _FakePurchaseVerificationSource(this.result);

  final PurchaseVerificationResult result;

  @override
  Future<PurchaseVerificationResult> verify(
    PurchaseVerificationRequest request,
  ) async {
    return result;
  }
}
