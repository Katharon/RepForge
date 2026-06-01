import '../entities/auth_status_snapshot.dart';

abstract interface class AuthGateway {
  Future<AuthStatusSnapshot> loadStatus();

  Future<AuthStatusSnapshot> signOut();
}
