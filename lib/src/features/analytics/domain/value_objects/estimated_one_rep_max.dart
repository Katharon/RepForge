import 'formula_identity.dart';

final class EstimatedOneRepMax {
  const EstimatedOneRepMax({
    required this.valueKg,
    required this.formulaIdentity,
  }) : assert(valueKg >= 0, 'Estimated 1RM must be non-negative.');

  final double valueKg;
  final FormulaIdentity formulaIdentity;

  @override
  bool operator ==(Object other) {
    return other is EstimatedOneRepMax &&
        other.valueKg == valueKg &&
        other.formulaIdentity == formulaIdentity;
  }

  @override
  int get hashCode => Object.hash(valueKg, formulaIdentity);
}
