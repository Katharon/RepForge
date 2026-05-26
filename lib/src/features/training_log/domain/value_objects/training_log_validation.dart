import '../exceptions/training_log_validation_exception.dart';

String requireNonBlank(String field, String value) {
  final trimmedValue = value.trim();
  if (trimmedValue.isEmpty) {
    throw TrainingLogValidationException(field, 'Must not be blank.');
  }

  return trimmedValue;
}

double requireNonNegativeFiniteLoadKg(String field, num value) {
  if (value.isNaN || value.isInfinite || value < 0) {
    throw TrainingLogValidationException(
      field,
      'Must be a finite value greater than or equal to zero.',
    );
  }

  return value.toDouble();
}

int requirePositiveInt(String field, int value) {
  if (value <= 0) {
    throw TrainingLogValidationException(field, 'Must be greater than zero.');
  }

  return value;
}
