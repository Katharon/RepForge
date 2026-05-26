import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import '../formulas/epley_one_rep_max_formula.dart';
import '../value_objects/estimated_one_rep_max.dart';
import '../value_objects/workout_set_analytics_summary.dart';

final class WorkoutSetAnalyticsFormulaService {
  const WorkoutSetAnalyticsFormulaService({
    this.oneRepMaxFormula = const EpleyOneRepMaxFormula(),
  });

  final EpleyOneRepMaxFormula oneRepMaxFormula;

  WorkoutSetAnalyticsSummary summarize(List<WorkoutSet> sets) {
    var totalRepetitions = 0;
    var totalVolumeKg = 0.0;
    double? bestSetLoadKg;
    EstimatedOneRepMax? bestEstimatedOneRepMax;

    for (final set in sets) {
      final repetitions = set.repetitions.value;
      final loadKg = set.load.value;
      final volumeKg = loadKg * repetitions;
      final estimatedOneRepMax = oneRepMaxFormula.estimate(
        load: set.load,
        repetitions: set.repetitions,
      );

      totalRepetitions += repetitions;
      totalVolumeKg += volumeKg;

      if (bestSetLoadKg == null || loadKg > bestSetLoadKg) {
        bestSetLoadKg = loadKg;
      }

      if (bestEstimatedOneRepMax == null ||
          estimatedOneRepMax.valueKg > bestEstimatedOneRepMax.valueKg) {
        bestEstimatedOneRepMax = estimatedOneRepMax;
      }
    }

    return WorkoutSetAnalyticsSummary(
      setCount: sets.length,
      totalRepetitions: totalRepetitions,
      totalVolumeKg: totalVolumeKg,
      averageKgPerRep: totalRepetitions == 0
          ? null
          : totalVolumeKg / totalRepetitions,
      bestSetLoadKg: bestSetLoadKg,
      bestEstimatedOneRepMax: bestEstimatedOneRepMax,
      oneRepMaxFormulaIdentity: oneRepMaxFormula.identity,
    );
  }
}
