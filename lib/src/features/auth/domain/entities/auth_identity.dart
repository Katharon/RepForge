import '../value_objects/auth_provider.dart';
import '../value_objects/auth_user_id.dart';

final class AuthIdentity {
  const AuthIdentity({
    required this.userId,
    required this.provider,
    this.displayName,
  });

  final AuthUserId userId;
  final AuthProvider provider;
  final String? displayName;

  @override
  bool operator ==(Object other) {
    return other is AuthIdentity &&
        other.userId == userId &&
        other.provider == provider &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => Object.hash(userId, provider, displayName);
}
