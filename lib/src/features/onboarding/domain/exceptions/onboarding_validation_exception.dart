final class OnboardingValidationException implements Exception {
  const OnboardingValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'OnboardingValidationException($field): $message';
}
