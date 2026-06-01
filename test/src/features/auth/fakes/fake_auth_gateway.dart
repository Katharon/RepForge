import 'package:repforge/src/features/auth/domain/auth_domain.dart';

final class FakeAuthGateway implements AuthGateway {
  FakeAuthGateway(this._status);

  AuthStatusSnapshot _status;
  int loadCount = 0;
  int signOutCount = 0;

  @override
  Future<AuthStatusSnapshot> loadStatus() async {
    loadCount += 1;
    return _status;
  }

  @override
  Future<AuthStatusSnapshot> signOut() async {
    signOutCount += 1;
    _status = AuthStatusSnapshot(
      capturedAt: _status.capturedAt,
      session: const AuthSession.signedOut(),
    );
    return _status;
  }
}
