import '../value_objects/onboarding_status.dart';

abstract interface class OnboardingStatusRepository {
  Future<OnboardingStatus> load();

  Future<void> save(OnboardingStatus status);
}
