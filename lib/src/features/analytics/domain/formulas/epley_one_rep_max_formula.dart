import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import '../value_objects/estimated_one_rep_max.dart';
import '../value_objects/formula_identity.dart';

final class EpleyOneRepMaxFormula {
  const EpleyOneRepMaxFormula();

  static final FormulaIdentity epleyV1 = FormulaIdentity(
    name: 'epley_one_rep_max',
    version: 1,
  );

  FormulaIdentity get identity => epleyV1;

  EstimatedOneRepMax estimate({
    required LoadKg load,
    required Repetitions repetitions,
  }) {
    final estimatedKg = load.value * (1 + repetitions.value / 30);

    return EstimatedOneRepMax(valueKg: estimatedKg, formulaIdentity: identity);
  }
}
