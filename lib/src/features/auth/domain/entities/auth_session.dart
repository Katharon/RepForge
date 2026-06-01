import '../value_objects/auth_failure.dart';
import 'auth_identity.dart';

enum AuthSessionState {
  localOnly,
  unauthenticated,
  authenticated,
  expired,
  unavailable,
  failed,
  signedOut,
}

final class AuthSession {
  const AuthSession._({
    required this.state,
    this.identity,
    this.authenticatedAt,
    this.expiresAt,
    this.failure,
  });

  const AuthSession.localOnly() : this._(state: AuthSessionState.localOnly);

  const AuthSession.unauthenticated()
    : this._(state: AuthSessionState.unauthenticated);

  const AuthSession.signedOut() : this._(state: AuthSessionState.signedOut);

  const AuthSession.unavailable() : this._(state: AuthSessionState.unavailable);

  const AuthSession.failed(AuthFailure failure)
    : this._(state: AuthSessionState.failed, failure: failure);

  const AuthSession.expired({
    required AuthIdentity identity,
    required DateTime authenticatedAt,
    required DateTime expiredAt,
  }) : this._(
         state: AuthSessionState.expired,
         identity: identity,
         authenticatedAt: authenticatedAt,
         expiresAt: expiredAt,
       );

  const AuthSession.authenticated({
    required AuthIdentity identity,
    required DateTime authenticatedAt,
    DateTime? expiresAt,
  }) : this._(
         state: AuthSessionState.authenticated,
         identity: identity,
         authenticatedAt: authenticatedAt,
         expiresAt: expiresAt,
       );

  final AuthSessionState state;
  final AuthIdentity? identity;
  final DateTime? authenticatedAt;
  final DateTime? expiresAt;
  final AuthFailure? failure;

  bool isAuthenticatedAt(DateTime evaluatedAt) {
    if (state != AuthSessionState.authenticated) {
      return false;
    }
    final expiresAt = this.expiresAt;
    if (expiresAt == null) {
      return true;
    }
    final evaluatedAtUtc = evaluatedAt.toUtc();
    final expiresAtUtc = expiresAt.toUtc();
    return expiresAtUtc.isAfter(evaluatedAtUtc);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthSession &&
        other.state == state &&
        other.identity == identity &&
        other.authenticatedAt == authenticatedAt &&
        other.expiresAt == expiresAt &&
        other.failure == failure;
  }

  @override
  int get hashCode =>
      Object.hash(state, identity, authenticatedAt, expiresAt, failure);
}
