import 'package:repforge/src/features/analytics/application/analytics_application.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import 'analytics_metric.dart';
import 'exercise_analytics_chart_range.dart';

const exerciseAnalyticsChartTimelineLimit = 100;

abstract interface class ExerciseAnalyticsChartLoader {
  Future<ExerciseAnalyticsChartViewModel> load(
    ExerciseAnalyticsChartLoadRequest request,
  );
}

final class ExerciseAnalyticsChartLoadRequest {
  ExerciseAnalyticsChartLoadRequest({
    required this.range,
    required DateTime now,
  }) : now = now.toUtc();

  final ExerciseAnalyticsChartRange range;
  final DateTime now;

  ExerciseAnalyticsPeriod? get period => range.periodEndingAt(now);
}

final class RepositoryExerciseAnalyticsChartLoader
    implements ExerciseAnalyticsChartLoader {
  const RepositoryExerciseAnalyticsChartLoader({
    required this.workoutSetRepository,
    required this.exerciseRef,
    this.title,
  });

  final WorkoutSetRepository workoutSetRepository;
  final ExerciseRef exerciseRef;
  final String? title;

  @override
  Future<ExerciseAnalyticsChartViewModel> load(
    ExerciseAnalyticsChartLoadRequest request,
  ) async {
    final page = await workoutSetRepository.timelineForExercise(
      WorkoutSetTimelineQuery(
        exerciseRef: exerciseRef,
        limit: exerciseAnalyticsChartTimelineLimit,
      ),
    );
    final period = request.period;
    final filtered = period == null
        ? page.items
        : page.items
              .where((set) => period.contains(set.performedAt.value))
              .toList(growable: false);
    final points =
        filtered
            .map(ExerciseAnalyticsChartPointViewModel.fromWorkoutSet)
            .toList()
          ..sort((a, b) {
            final performedAtComparison = a.performedAt.compareTo(
              b.performedAt,
            );
            if (performedAtComparison != 0) {
              return performedAtComparison;
            }
            return a.id.compareTo(b.id);
          });

    return ExerciseAnalyticsChartViewModel(
      exerciseRef: exerciseRef,
      title: title ?? exerciseRef.displayNameSnapshot,
      range: request.range,
      points: points,
      reachedHistoryLimit: page.hasMore,
    );
  }
}

final class ExerciseAnalyticsChartViewModel {
  ExerciseAnalyticsChartViewModel({
    required this.exerciseRef,
    required this.title,
    required this.range,
    required Iterable<ExerciseAnalyticsChartPointViewModel> points,
    required this.reachedHistoryLimit,
  }) : points = List<ExerciseAnalyticsChartPointViewModel>.unmodifiable(points);

  final ExerciseRef exerciseRef;
  final String title;
  final ExerciseAnalyticsChartRange range;
  final List<ExerciseAnalyticsChartPointViewModel> points;
  final bool reachedHistoryLimit;

  bool get hasPoints => points.isNotEmpty;

  ExerciseAnalyticsChartViewModel copyWith({
    String? title,
    ExerciseAnalyticsChartRange? range,
    Iterable<ExerciseAnalyticsChartPointViewModel>? points,
    bool? reachedHistoryLimit,
  }) {
    return ExerciseAnalyticsChartViewModel(
      exerciseRef: exerciseRef,
      title: title ?? this.title,
      range: range ?? this.range,
      points: points ?? this.points,
      reachedHistoryLimit: reachedHistoryLimit ?? this.reachedHistoryLimit,
    );
  }
}

final class ExerciseAnalyticsChartPointViewModel {
  ExerciseAnalyticsChartPointViewModel({
    required this.id,
    required DateTime performedAt,
    required this.repetitions,
    required this.loadKg,
  }) : performedAt = performedAt.toLocal();

  factory ExerciseAnalyticsChartPointViewModel.fromWorkoutSet(WorkoutSet set) {
    return ExerciseAnalyticsChartPointViewModel(
      id: set.id.value,
      performedAt: set.performedAt.value,
      repetitions: set.repetitions.value,
      loadKg: set.load.value,
    );
  }

  final String id;
  final DateTime performedAt;
  final int repetitions;
  final double loadKg;

  double get volumeKg => loadKg * repetitions;

  double get kgPerRep => loadKg;

  double get estimatedOneRepMaxKg {
    final estimate = const EpleyOneRepMaxFormula().estimate(
      load: LoadKg(loadKg),
      repetitions: Repetitions(repetitions),
    );
    return estimate.valueKg;
  }

  double valueFor(AnalyticsMetric metric) {
    return switch (metric) {
      AnalyticsMetric.sets => 1,
      AnalyticsMetric.repetitions => repetitions.toDouble(),
      AnalyticsMetric.volumeKg => volumeKg,
      AnalyticsMetric.kgPerRep => kgPerRep,
      AnalyticsMetric.estimatedOneRepMaxKg => estimatedOneRepMaxKg,
    };
  }
}
