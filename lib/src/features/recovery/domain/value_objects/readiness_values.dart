import '../exceptions/recovery_validation_exception.dart';

final class ReadinessCheckInId {
  factory ReadinessCheckInId(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw const RecoveryValidationException(
        'readinessCheckInId',
        'Readiness check-in id must not be blank.',
      );
    }
    return ReadinessCheckInId._(normalized);
  }

  const ReadinessCheckInId._(this.value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is ReadinessCheckInId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class SorenessRating {
  factory SorenessRating(num value) {
    final normalized = _validatedInteger(
      field: 'soreness',
      value: value,
      minimum: 0,
      maximum: 4,
    );
    return SorenessRating._(normalized);
  }

  const SorenessRating._(this.value);

  factory SorenessRating.none() => SorenessRating(0);
  factory SorenessRating.light() => SorenessRating(1);
  factory SorenessRating.moderate() => SorenessRating(2);
  factory SorenessRating.high() => SorenessRating(3);
  factory SorenessRating.veryHigh() => SorenessRating(4);

  final int value;

  @override
  bool operator ==(Object other) {
    return other is SorenessRating && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class SleepQualityRating {
  factory SleepQualityRating(num value) {
    return SleepQualityRating._(
      _validatedInteger(
        field: 'sleepQuality',
        value: value,
        minimum: 1,
        maximum: 5,
      ),
    );
  }

  const SleepQualityRating._(this.value);

  final int value;

  @override
  bool operator ==(Object other) {
    return other is SleepQualityRating && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class EnergyRating {
  factory EnergyRating(num value) {
    return EnergyRating._(
      _validatedInteger(field: 'energy', value: value, minimum: 1, maximum: 5),
    );
  }

  const EnergyRating._(this.value);

  final int value;

  @override
  bool operator ==(Object other) {
    return other is EnergyRating && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class StressRating {
  factory StressRating(num value) {
    return StressRating._(
      _validatedInteger(field: 'stress', value: value, minimum: 1, maximum: 5),
    );
  }

  const StressRating._(this.value);

  final int value;

  @override
  bool operator ==(Object other) {
    return other is StressRating && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class MotivationRating {
  factory MotivationRating(num value) {
    return MotivationRating._(
      _validatedInteger(
        field: 'motivation',
        value: value,
        minimum: 1,
        maximum: 5,
      ),
    );
  }

  const MotivationRating._(this.value);

  final int value;

  @override
  bool operator ==(Object other) {
    return other is MotivationRating && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class ReadinessScore {
  factory ReadinessScore(num value) {
    if (!value.isFinite || value < 0 || value > 100) {
      throw const RecoveryValidationException(
        'readinessScore',
        'Readiness score must be finite and between 0 and 100.',
      );
    }
    return ReadinessScore._(value.round());
  }

  const ReadinessScore._(this.value);

  final int value;

  @override
  bool operator ==(Object other) {
    return other is ReadinessScore && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

int _validatedInteger({
  required String field,
  required num value,
  required int minimum,
  required int maximum,
}) {
  if (!value.isFinite || value % 1 != 0 || value < minimum || value > maximum) {
    throw RecoveryValidationException(
      field,
      '$field must be a finite integer between $minimum and $maximum.',
    );
  }

  return value.toInt();
}
