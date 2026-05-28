import '../application/analytics_application.dart';
import 'analytics_metric.dart';

final class ExerciseAnalyticsViewModel {
  const ExerciseAnalyticsViewModel({
    required this.exerciseName,
    required this.metricCards,
    required this.estimatedOneRepMax,
  });

  factory ExerciseAnalyticsViewModel.fromReadModel(
    ExerciseAnalyticsReadModel model,
  ) {
    final current = model.overview;
    final previous = model.timeWindow.previous;

    return ExerciseAnalyticsViewModel(
      exerciseName: model.exerciseRef.displayNameSnapshot,
      estimatedOneRepMax: EstimatedOneRepMaxViewModel(
        currentValueKg: current.bestEstimatedOneRepMaxKg.value,
        previousValueKg: previous?.bestEstimatedOneRepMaxKg.value,
        formulaName: current.bestEstimatedOneRepMaxFormulaIdentity.name,
        formulaVersion: current.bestEstimatedOneRepMaxFormulaIdentity.version,
        isAvailable: current.bestEstimatedOneRepMaxKg.isAvailable,
      ),
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
  final EstimatedOneRepMaxViewModel estimatedOneRepMax;

  AnalyticsMetricCardViewModel cardFor(AnalyticsMetric metric) {
    return metricCards.singleWhere((card) => card.metric == metric);
  }
}

final class EstimatedOneRepMaxViewModel {
  const EstimatedOneRepMaxViewModel({
    required this.currentValueKg,
    required this.previousValueKg,
    required this.formulaName,
    required this.formulaVersion,
    required this.isAvailable,
  });

  final double? currentValueKg;
  final double? previousValueKg;
  final String formulaName;
  final int formulaVersion;
  final bool isAvailable;
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
