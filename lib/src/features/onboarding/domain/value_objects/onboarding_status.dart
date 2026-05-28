enum OnboardingStep { welcome, profile, training, equipment, complete }

enum OnboardingCompletion { notStarted, skipped, completed }

final class OnboardingStatus {
  const OnboardingStatus({required this.completion, this.updatedAt});

  factory OnboardingStatus.notStarted() {
    return const OnboardingStatus(completion: OnboardingCompletion.notStarted);
  }

  final OnboardingCompletion completion;
  final DateTime? updatedAt;

  bool get shouldShowOnboarding =>
      completion == OnboardingCompletion.notStarted;

  @override
  bool operator ==(Object other) {
    return other is OnboardingStatus &&
        other.completion == completion &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(completion, updatedAt);
}
