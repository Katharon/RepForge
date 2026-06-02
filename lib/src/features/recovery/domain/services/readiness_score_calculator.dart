import '../entities/readiness_check_in.dart';
import '../value_objects/readiness_read_model.dart';
import '../value_objects/readiness_values.dart';

final class ReadinessScoreResult {
  ReadinessScoreResult({
    required this.score,
    required this.level,
    required Iterable<ReadinessReason> reasons,
  }) : reasons = List<ReadinessReason>.unmodifiable(reasons);

  final ReadinessScore score;
  final ReadinessLevel level;
  final List<ReadinessReason> reasons;
  ReadinessConfidence get confidence => ReadinessConfidence.reported;
  bool get allowsWorkoutLogging => true;

  @override
  bool operator ==(Object other) {
    return other is ReadinessScoreResult &&
        other.score == score &&
        other.level == level &&
        _listEquals(other.reasons, reasons);
  }

  @override
  int get hashCode => Object.hash(score, level, Object.hashAll(reasons));
}

final class ReadinessScoreCalculator {
  const ReadinessScoreCalculator();

  ReadinessScoreResult calculate(ReadinessCheckIn checkIn) {
    final rawScore =
        100 -
        (checkIn.soreness.value * 10) -
        ((5 - checkIn.sleepQuality.value) * 5) -
        ((5 - checkIn.energy.value) * 5) -
        ((checkIn.stress.value - 1) * 2) -
        ((5 - checkIn.motivation.value) * 1);
    final score = ReadinessScore(rawScore.clamp(0, 100));
    final reasons = <ReadinessReason>[];

    if (checkIn.soreness.value >= 3) {
      reasons.add(ReadinessReason.highSoreness);
    }
    if (checkIn.sleepQuality.value <= 2) {
      reasons.add(ReadinessReason.poorSleep);
    }
    if (checkIn.energy.value <= 2) {
      reasons.add(ReadinessReason.lowEnergy);
    }
    if (checkIn.stress.value >= 4) {
      reasons.add(ReadinessReason.highStress);
    }
    if (checkIn.motivation.value <= 2) {
      reasons.add(ReadinessReason.lowMotivation);
    }

    return ReadinessScoreResult(
      score: score,
      level: _levelFor(score),
      reasons: reasons,
    );
  }

  ReadinessLevel _levelFor(ReadinessScore score) {
    if (score.value >= 80) {
      return ReadinessLevel.high;
    }
    if (score.value >= 60) {
      return ReadinessLevel.medium;
    }
    if (score.value >= 40) {
      return ReadinessLevel.low;
    }

    return ReadinessLevel.veryLow;
  }
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }

  return true;
}
