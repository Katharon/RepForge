import '../entities/workout_set.dart';
import '../exceptions/training_log_validation_exception.dart';

final class WorkoutSetDailySummaryQuery {
  WorkoutSetDailySummaryQuery({
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) : startInclusive = startInclusive.toUtc(),
       endExclusive = endExclusive.toUtc() {
    if (!this.endExclusive.isAfter(this.startInclusive)) {
      throw const TrainingLogValidationException(
        'workoutSetDailySummary.endExclusive',
        'Must be after startInclusive.',
      );
    }
  }

  final DateTime startInclusive;
  final DateTime endExclusive;
}

final class WorkoutSetDailySummary {
  const WorkoutSetDailySummary({
    required this.setCount,
    required this.totalVolumeKg,
    required this.lastLoggedSet,
  });

  final int setCount;
  final double totalVolumeKg;
  final WorkoutSet? lastLoggedSet;

  bool get hasLoggedSets => setCount > 0;
}
