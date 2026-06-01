import 'auth_session.dart';

final class AuthStatusSnapshot {
  const AuthStatusSnapshot({required this.capturedAt, required this.session});

  final DateTime capturedAt;
  final AuthSession session;

  @override
  bool operator ==(Object other) {
    return other is AuthStatusSnapshot &&
        other.capturedAt == capturedAt &&
        other.session == session;
  }

  @override
  int get hashCode => Object.hash(capturedAt, session);
}
