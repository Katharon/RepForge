import '../exceptions/training_log_validation_exception.dart';

enum WorkoutSetLabel {
  none('none'),
  warmup('warmup'),
  failure('failure'),
  personalRecord('personalRecord'),
  dropSet('dropSet'),
  pain('pain');

  const WorkoutSetLabel(this.storageValue);

  final String storageValue;

  static WorkoutSetLabel fromStorageValue(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return WorkoutSetLabel.none;
    }

    for (final label in WorkoutSetLabel.values) {
      if (label.storageValue == normalized) {
        return label;
      }
    }

    throw TrainingLogValidationException(
      'setLabel',
      'Unsupported persisted set label: $normalized.',
    );
  }
}
