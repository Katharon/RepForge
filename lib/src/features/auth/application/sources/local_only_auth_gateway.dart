import 'package:repforge/src/features/auth/domain/auth_domain.dart';

final class LocalOnlyAuthGateway implements AuthGateway {
  LocalOnlyAuthGateway({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  @override
  Future<AuthStatusSnapshot> loadStatus() async {
    return AuthStatusSnapshot(
      capturedAt: _now().toUtc(),
      session: const AuthSession.localOnly(),
    );
  }

  @override
  Future<AuthStatusSnapshot> signOut() async {
    return AuthStatusSnapshot(
      capturedAt: _now().toUtc(),
      session: const AuthSession.signedOut(),
    );
  }
}
