import '../../domain/onboarding_domain.dart';

final class SkipOnboarding {
  const SkipOnboarding(this._repository, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final OnboardingStatusRepository _repository;
  final DateTime Function() _now;

  Future<OnboardingStatus> call() async {
    final status = OnboardingStatus(
      completion: OnboardingCompletion.skipped,
      updatedAt: _now().toUtc(),
    );
    await _repository.save(status);
    return status;
  }
}
