import '../exceptions/analytics_validation_exception.dart';
import 'formula_identity.dart';

final class EstimatedOneRepMax {
  EstimatedOneRepMax({required double valueKg, required this.formulaIdentity})
    : valueKg = _requireNonNegativeFinite(
        'estimatedOneRepMax.valueKg',
        valueKg,
      );

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

double _requireNonNegativeFinite(String field, double value) {
  if (value.isNaN || value.isInfinite || value < 0) {
    throw AnalyticsValidationException(
      field,
      'Must be a finite value greater than or equal to zero.',
    );
  }

  return value;
}
