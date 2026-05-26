import 'estimated_one_rep_max.dart';
import 'formula_identity.dart';

final class WorkoutSetAnalyticsSummary {
  const WorkoutSetAnalyticsSummary({
    required this.setCount,
    required this.totalRepetitions,
    required this.totalVolumeKg,
    required this.averageKgPerRep,
    required this.bestSetLoadKg,
    required this.bestEstimatedOneRepMax,
    required this.oneRepMaxFormulaIdentity,
  });

  final int setCount;
  final int totalRepetitions;
  final double totalVolumeKg;
  final double? averageKgPerRep;
  final double? bestSetLoadKg;
  final EstimatedOneRepMax? bestEstimatedOneRepMax;
  final FormulaIdentity oneRepMaxFormulaIdentity;

  @override
  bool operator ==(Object other) {
    return other is WorkoutSetAnalyticsSummary &&
        other.setCount == setCount &&
        other.totalRepetitions == totalRepetitions &&
        other.totalVolumeKg == totalVolumeKg &&
        other.averageKgPerRep == averageKgPerRep &&
        other.bestSetLoadKg == bestSetLoadKg &&
        other.bestEstimatedOneRepMax == bestEstimatedOneRepMax &&
        other.oneRepMaxFormulaIdentity == oneRepMaxFormulaIdentity;
  }

  @override
  int get hashCode {
    return Object.hash(
      setCount,
      totalRepetitions,
      totalVolumeKg,
      averageKgPerRep,
      bestSetLoadKg,
      bestEstimatedOneRepMax,
      oneRepMaxFormulaIdentity,
    );
  }
}
