import '../../domain/onboarding_domain.dart';

final class LoadOnboardingStatus {
  const LoadOnboardingStatus(this._repository);

  final OnboardingStatusRepository _repository;

  Future<OnboardingStatus> call() => _repository.load();
}
