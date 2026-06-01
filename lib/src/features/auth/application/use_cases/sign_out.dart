import 'package:repforge/src/features/auth/domain/auth_domain.dart';

final class SignOut {
  const SignOut(this._gateway);

  final AuthGateway _gateway;

  Future<AuthStatusSnapshot> call() => _gateway.signOut();
}
