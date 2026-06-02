import '../exceptions/settings_validation_exception.dart';
import '../value_objects/settings_enums.dart';

final class UserProfile {
  UserProfile({
    String? displayName,
    this.sexGender = SexGenderPreference.unspecified,
    this.birthYear,
    this.bodyWeightKg,
    this.heightCm,
  }) : displayName = _normalize(displayName);

  factory UserProfile.empty() => UserProfile();

  final String? displayName;
  final SexGenderPreference sexGender;
  final BirthYear? birthYear;
  final BodyWeightKg? bodyWeightKg;
  final HeightCm? heightCm;

  @override
  bool operator ==(Object other) {
    return other is UserProfile &&
        other.displayName == displayName &&
        other.sexGender == sexGender &&
        other.birthYear == birthYear &&
        other.bodyWeightKg == bodyWeightKg &&
        other.heightCm == heightCm;
  }

  @override
  int get hashCode {
    return Object.hash(
      displayName,
      sexGender,
      birthYear,
      bodyWeightKg,
      heightCm,
    );
  }
}

final class BirthYear {
  BirthYear(this.value) {
    final currentYear = DateTime.now().toUtc().year;
    if (value < 1900 || value > currentYear) {
      throw const SettingsValidationException(
        'birthYear',
        'Must be between 1900 and the current year.',
      );
    }
  }

  final int value;

  @override
  bool operator ==(Object other) {
    return other is BirthYear && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class BodyWeightKg {
  BodyWeightKg(this.value) {
    if (!value.isFinite || value <= 0 || value > 500) {
      throw const SettingsValidationException(
        'bodyWeightKg',
        'Must be greater than zero and 500 kg or less.',
      );
    }
  }

  final double value;

  @override
  bool operator ==(Object other) {
    return other is BodyWeightKg && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class HeightCm {
  HeightCm(this.value) {
    if (!value.isFinite || value <= 0 || value > 300) {
      throw const SettingsValidationException(
        'heightCm',
        'Must be greater than zero and 300 cm or less.',
      );
    }
  }

  final double value;

  @override
  bool operator ==(Object other) {
    return other is HeightCm && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
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
