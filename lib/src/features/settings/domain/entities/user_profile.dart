import '../exceptions/settings_validation_exception.dart';

final class UserProfile {
  UserProfile({String? displayName}) : displayName = _normalize(displayName);

  factory UserProfile.empty() => UserProfile();

  final String? displayName;

  @override
  bool operator ==(Object other) {
    return other is UserProfile && other.displayName == displayName;
  }

  @override
  int get hashCode => displayName.hashCode;
}

String? _normalize(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  if (trimmed.length > 80) {
    throw const SettingsValidationException(
      'displayName',
      'Must be 80 characters or fewer.',
    );
  }
  return trimmed;
}
