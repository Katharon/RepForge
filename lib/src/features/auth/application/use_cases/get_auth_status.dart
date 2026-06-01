import 'package:repforge/src/features/auth/domain/auth_domain.dart';

final class GetAuthStatus {
  const GetAuthStatus(this._gateway);

  final AuthGateway _gateway;

  Future<AuthStatusSnapshot> call() => _gateway.loadStatus();
}
