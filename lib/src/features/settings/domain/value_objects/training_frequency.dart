import '../exceptions/settings_validation_exception.dart';

final class TrainingFrequency {
  TrainingFrequency(this.daysPerWeek) {
    if (daysPerWeek < 1 || daysPerWeek > 7) {
      throw const SettingsValidationException(
        'trainingDaysPerWeek',
        'Must be between 1 and 7.',
      );
    }
  }

  final int daysPerWeek;

  @override
  bool operator ==(Object other) {
    return other is TrainingFrequency && other.daysPerWeek == daysPerWeek;
  }

  @override
  int get hashCode => daysPerWeek.hashCode;
}
