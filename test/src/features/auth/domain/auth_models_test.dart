import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/auth/domain/auth_domain.dart';

void main() {
  group('auth domain models', () {
    test('AuthUserId trims and rejects blank values', () {
      expect(AuthUserId(' user-1 ').value, 'user-1');
      expect(() => AuthUserId(' '), throwsA(isA<AuthValidationException>()));
    });

    test('authenticated session requires identity', () {
      final now = DateTime.utc(2026, 6);
      final session = AuthSession.authenticated(
        identity: AuthIdentity(
          userId: AuthUserId('user-1'),
          provider: AuthProvider.localTest,
        ),
        authenticatedAt: now,
      );

      expect(session.state, AuthSessionState.authenticated);
      expect(session.isAuthenticatedAt(now), isTrue);
    });

    test('expired session is not authenticated at evaluation time', () {
      final now = DateTime.utc(2026, 6);
      final session = AuthSession.authenticated(
        identity: AuthIdentity(
          userId: AuthUserId('user-1'),
          provider: AuthProvider.localTest,
        ),
        authenticatedAt: now.subtract(const Duration(hours: 2)),
        expiresAt: now.subtract(const Duration(seconds: 1)),
      );

      expect(session.isAuthenticatedAt(now), isFalse);
    });
  });
}
