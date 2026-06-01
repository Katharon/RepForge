import 'package:repforge/src/features/auth/domain/auth_domain.dart';

final class AuthSessionPolicy {
  const AuthSessionPolicy();

  bool allowsLocalUse(AuthStatusSnapshot snapshot) => true;

  bool requiresAccountForLocalUse(AuthStatusSnapshot snapshot) => false;
}
