import '../exceptions/rest_timer_validation_exception.dart';

final class RestTimerDuration {
  RestTimerDuration(Duration value) : value = _requirePositive(value);

  final Duration value;

  int get inSeconds => value.inSeconds;

  @override
  bool operator ==(Object other) {
    return other is RestTimerDuration && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

Duration _requirePositive(Duration value) {
  if (value <= Duration.zero) {
    throw const RestTimerValidationException(
      'duration',
      'Must be greater than zero.',
    );
  }

  return value;
}
