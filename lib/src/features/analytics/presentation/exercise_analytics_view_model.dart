import '../application/analytics_application.dart';
import 'analytics_metric.dart';

final class ExerciseAnalyticsViewModel {
  const ExerciseAnalyticsViewModel({
    required this.exerciseName,
    required this.metricCards,
  });

  factory ExerciseAnalyticsViewModel.fromReadModel(
    ExerciseAnalyticsReadModel model,
  ) {
    final current = model.overview;
    final previous = model.timeWindow.previous;

    return ExerciseAnalyticsViewModel(
      exerciseName: model.exerciseRef.displayNameSnapshot,
      metricCards: [
        AnalyticsMetricCardViewModel(
          metric: AnalyticsMetric.sets,
          currentValue: current.setCount.toDouble(),
          previousValue: previous?.setCount.toDouble(),
          isAvailable: true,
        ),
        AnalyticsMetricCardViewModel(
          metric: AnalyticsMetric.repetitions,
          currentValue: current.totalRepetitions.toDouble(),
          previousValue: previous?.totalRepetitions.toDouble(),
          isAvailable: true,
        ),
        AnalyticsMetricCardViewModel(
          metric: AnalyticsMetric.volumeKg,
          currentValue: current.totalVolumeKg,
          previousValue: previous?.totalVolumeKg,
          isAvailable: true,
        ),
        AnalyticsMetricCardViewModel(
          metric: AnalyticsMetric.kgPerRep,
          currentValue: current.averageKgPerRep.value,
          previousValue: previous?.averageKgPerRep.value,
          isAvailable: current.averageKgPerRep.isAvailable,
        ),
        AnalyticsMetricCardViewModel(
          metric: AnalyticsMetric.estimatedOneRepMaxKg,
          currentValue: current.bestEstimatedOneRepMaxKg.value,
          previousValue: previous?.bestEstimatedOneRepMaxKg.value,
          isAvailable: current.bestEstimatedOneRepMaxKg.isAvailable,
        ),
      ],
    );
  }

  final String exerciseName;
  final List<AnalyticsMetricCardViewModel> metricCards;

  AnalyticsMetricCardViewModel cardFor(AnalyticsMetric metric) {
    return metricCards.singleWhere((card) => card.metric == metric);
  }
}

final class AnalyticsMetricCardViewModel {
  const AnalyticsMetricCardViewModel({
    required this.metric,
    required this.currentValue,
    required this.previousValue,
    required this.isAvailable,
  });

  final AnalyticsMetric metric;
  final double? currentValue;
  final double? previousValue;
  final bool isAvailable;

  double get chartMaximum {
    final current = currentValue ?? 0;
    final previous = previousValue ?? 0;
    final maximum = current > previous ? current : previous;

    return maximum <= 0 ? 1 : maximum;
  }
}
