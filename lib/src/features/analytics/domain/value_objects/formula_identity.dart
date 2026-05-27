import '../exceptions/analytics_validation_exception.dart';

final class FormulaIdentity {
  FormulaIdentity({required String name, required int version})
    : name = _requireNonBlank('formulaIdentity.name', name),
      version = _requirePositive('formulaIdentity.version', version);

  final String name;
  final int version;

  @override
  bool operator ==(Object other) {
    return other is FormulaIdentity &&
        other.name == name &&
        other.version == version;
  }

  @override
  int get hashCode => Object.hash(name, version);

  @override
  String toString() => '$name/v$version';
}

String _requireNonBlank(String field, String value) {
  final trimmedValue = value.trim();
  if (trimmedValue.isEmpty) {
    throw AnalyticsValidationException(field, 'Must not be blank.');
  }

  return trimmedValue;
}

int _requirePositive(String field, int value) {
  if (value <= 0) {
    throw AnalyticsValidationException(field, 'Must be greater than zero.');
  }

  return value;
}
