import '../entities/readiness_check_in.dart';
import 'readiness_values.dart';

enum ReadinessLevel { high, medium, low, veryLow }

enum ReadinessConfidence { unavailable, reported }

enum ReadinessReason {
  noCheckIn,
  highSoreness,
  poorSleep,
  lowEnergy,
  highStress,
  lowMotivation,
}

enum ReadinessReadModelStatus { empty, available }

final class ReadinessReadModel {
  ReadinessReadModel({
    required this.status,
    required this.forDate,
    required this.confidence,
    required this.latestCheckIn,
    required this.score,
    required this.level,
    required Iterable<ReadinessReason> reasons,
  }) : reasons = List<ReadinessReason>.unmodifiable(reasons);

  factory ReadinessReadModel.empty({required DateTime forDate}) {
    return ReadinessReadModel(
      status: ReadinessReadModelStatus.empty,
      forDate: forDate.toUtc(),
      confidence: ReadinessConfidence.unavailable,
      latestCheckIn: null,
      score: null,
      level: null,
      reasons: const <ReadinessReason>[ReadinessReason.noCheckIn],
    );
  }

  final ReadinessReadModelStatus status;
  final DateTime forDate;
  final ReadinessConfidence confidence;
  final ReadinessCheckIn? latestCheckIn;
  final ReadinessScore? score;
  final ReadinessLevel? level;
  final List<ReadinessReason> reasons;

  bool get allowsWorkoutLogging => true;

  @override
  bool operator ==(Object other) {
    return other is ReadinessReadModel &&
        other.status == status &&
        other.forDate == forDate &&
        other.confidence == confidence &&
        other.latestCheckIn == latestCheckIn &&
        other.score == score &&
        other.level == level &&
        _listEquals(other.reasons, reasons);
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      forDate,
      confidence,
      latestCheckIn,
      score,
      level,
      Object.hashAll(reasons),
    );
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
