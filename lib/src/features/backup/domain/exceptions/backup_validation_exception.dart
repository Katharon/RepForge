final class BackupValidationError {
  const BackupValidationError({required this.field, required this.message});

  final String field;
  final String message;

  @override
  String toString() => '$field: $message';

  @override
  bool operator ==(Object other) {
    return other is BackupValidationError &&
        other.field == field &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(field, message);
}

final class BackupValidationException implements Exception {
  BackupValidationException(Iterable<BackupValidationError> errors)
    : errors = List<BackupValidationError>.unmodifiable(errors) {
    if (this.errors.isEmpty) {
      throw ArgumentError.value(errors, 'errors', 'Must not be empty.');
    }
  }

  final List<BackupValidationError> errors;

  @override
  String toString() => errors.map((error) => error.toString()).join('; ');
}
