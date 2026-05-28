import '../exceptions/settings_validation_exception.dart';

final class DefaultRestTime {
  DefaultRestTime(Duration value) : value = _validate(value);

  factory DefaultRestTime.seconds(int seconds) {
    return DefaultRestTime(Duration(seconds: seconds));
  }

  static DefaultRestTime get standard => DefaultRestTime.seconds(90);

  final Duration value;

  int get inSeconds => value.inSeconds;

  @override
  bool operator ==(Object other) {
    return other is DefaultRestTime && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

Duration _validate(Duration value) {
  if (value <= Duration.zero) {
    throw const SettingsValidationException(
      'defaultRestTime',
      'Must be greater than zero.',
    );
  }
  if (value > const Duration(minutes: 30)) {
    throw const SettingsValidationException(
      'defaultRestTime',
      'Must be 30 minutes or less.',
    );
  }
  return value;
}
