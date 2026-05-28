import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

final class ExerciseAnalyticsPeriod {
  ExerciseAnalyticsPeriod({required DateTime start, required DateTime end})
    : start = start.toUtc(),
      end = end.toUtc() {
    if (!this.end.isAfter(this.start)) {
      throw const AnalyticsValidationException(
        'exerciseAnalyticsPeriod.end',
        'Must be after start.',
      );
    }
  }

  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);

  ExerciseAnalyticsPeriod get previousEqualLength {
    return ExerciseAnalyticsPeriod(start: start.subtract(duration), end: start);
  }

  bool contains(DateTime value) {
    final utcValue = value.toUtc();
    return !utcValue.isBefore(start) && utcValue.isBefore(end);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseAnalyticsPeriod &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}

final class ExerciseMetricValue {
  const ExerciseMetricValue.available(this.value) : isAvailable = true;

  const ExerciseMetricValue.unavailable() : value = null, isAvailable = false;

  final double? value;
  final bool isAvailable;

  @override
  bool operator ==(Object other) {
    return other is ExerciseMetricValue &&
        other.value == value &&
        other.isAvailable == isAvailable;
  }

  @override
  int get hashCode => Object.hash(value, isAvailable);
}

final class ExerciseMetricDelta {
  const ExerciseMetricDelta({
    required this.current,
    required this.previous,
    required this.absoluteDelta,
    required this.percentChange,
  });

  factory ExerciseMetricDelta.fromValues({
    required num current,
    num? previous,
  }) {
    final currentValue = current.toDouble();
    final previousValue = previous?.toDouble();
    final absoluteDelta = previousValue == null
        ? null
        : currentValue - previousValue;
    final percentChange = previousValue == null || previousValue == 0
        ? null
        : absoluteDelta! / previousValue;

    return ExerciseMetricDelta(
      current: currentValue,
      previous: previousValue,
      absoluteDelta: absoluteDelta,
      percentChange: percentChange,
    );
  }

  final double current;
  final double? previous;
  final double? absoluteDelta;
  final double? percentChange;

  bool get isAvailable => previous != null;

  @override
  bool operator ==(Object other) {
    return other is ExerciseMetricDelta &&
        other.current == current &&
        other.previous == previous &&
        other.absoluteDelta == absoluteDelta &&
        other.percentChange == percentChange;
  }

  @override
  int get hashCode {
    return Object.hash(current, previous, absoluteDelta, percentChange);
  }
}

final class ExerciseAnalyticsOverview {
  ExerciseAnalyticsOverview.fromSummary(WorkoutSetAnalyticsSummary summary)
    : setCount = summary.setCount,
      totalRepetitions = summary.totalRepetitions,
      totalVolumeKg = summary.totalVolumeKg,
      averageKgPerRep = summary.averageKgPerRep == null
          ? const ExerciseMetricValue.unavailable()
          : ExerciseMetricValue.available(summary.averageKgPerRep!),
      bestEstimatedOneRepMaxKg = summary.bestEstimatedOneRepMax == null
          ? const ExerciseMetricValue.unavailable()
          : ExerciseMetricValue.available(
              summary.bestEstimatedOneRepMax!.valueKg,
            ),
      bestEstimatedOneRepMaxFormulaIdentity =
          summary.bestEstimatedOneRepMax?.formulaIdentity ??
          summary.oneRepMaxFormulaIdentity;

  final int setCount;
  final int totalRepetitions;
  final double totalVolumeKg;
  final ExerciseMetricValue averageKgPerRep;
  final ExerciseMetricValue bestEstimatedOneRepMaxKg;
  final FormulaIdentity bestEstimatedOneRepMaxFormulaIdentity;

  bool get isEmpty => setCount == 0;

  @override
  bool operator ==(Object other) {
    return other is ExerciseAnalyticsOverview &&
        other.setCount == setCount &&
        other.totalRepetitions == totalRepetitions &&
        other.totalVolumeKg == totalVolumeKg &&
        other.averageKgPerRep == averageKgPerRep &&
        other.bestEstimatedOneRepMaxKg == bestEstimatedOneRepMaxKg &&
        other.bestEstimatedOneRepMaxFormulaIdentity ==
            bestEstimatedOneRepMaxFormulaIdentity;
  }

  @override
  int get hashCode {
    return Object.hash(
      setCount,
      totalRepetitions,
      totalVolumeKg,
      averageKgPerRep,
      bestEstimatedOneRepMaxKg,
      bestEstimatedOneRepMaxFormulaIdentity,
    );
  }
}

enum ExerciseAnalyticsComparisonAvailability {
  available,
  missingCurrent,
  missingPrevious,
}

final class ExerciseAnalyticsComparison {
  const ExerciseAnalyticsComparison({
    required this.current,
    required this.previous,
    required this.availability,
    required this.totalVolumeKgDelta,
    required this.bestEstimatedOneRepMaxKgDelta,
  });

  final ExerciseAnalyticsOverview current;
  final ExerciseAnalyticsOverview? previous;
  final ExerciseAnalyticsComparisonAvailability availability;
  final ExerciseMetricDelta totalVolumeKgDelta;
  final ExerciseMetricDelta bestEstimatedOneRepMaxKgDelta;

  bool get isAvailable {
    return availability == ExerciseAnalyticsComparisonAvailability.available;
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseAnalyticsComparison &&
        other.current == current &&
        other.previous == previous &&
        other.availability == availability &&
        other.totalVolumeKgDelta == totalVolumeKgDelta &&
        other.bestEstimatedOneRepMaxKgDelta == bestEstimatedOneRepMaxKgDelta;
  }

  @override
  int get hashCode {
    return Object.hash(
      current,
      previous,
      availability,
      totalVolumeKgDelta,
      bestEstimatedOneRepMaxKgDelta,
    );
  }
}

final class ExerciseAnalyticsReadModel {
  const ExerciseAnalyticsReadModel({
    required this.exerciseRef,
    required this.period,
    required this.previousPeriod,
    required this.overview,
    required this.previousComparableSession,
    required this.timeWindow,
    required this.scannedSetCount,
    required this.reachedHistoryLimit,
  });

  final ExerciseRef exerciseRef;
  final ExerciseAnalyticsPeriod period;
  final ExerciseAnalyticsPeriod previousPeriod;
  final ExerciseAnalyticsOverview overview;
  final ExerciseAnalyticsComparison previousComparableSession;
  final ExerciseAnalyticsComparison timeWindow;
  final int scannedSetCount;
  final bool reachedHistoryLimit;

  @override
  bool operator ==(Object other) {
    return other is ExerciseAnalyticsReadModel &&
        other.exerciseRef == exerciseRef &&
        other.period == period &&
        other.previousPeriod == previousPeriod &&
        other.overview == overview &&
        other.previousComparableSession == previousComparableSession &&
        other.timeWindow == timeWindow &&
        other.scannedSetCount == scannedSetCount &&
        other.reachedHistoryLimit == reachedHistoryLimit;
  }

  @override
  int get hashCode {
    return Object.hash(
      exerciseRef,
      period,
      previousPeriod,
      overview,
      previousComparableSession,
      timeWindow,
      scannedSetCount,
      reachedHistoryLimit,
    );
  }
}
