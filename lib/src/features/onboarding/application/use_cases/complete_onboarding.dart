import '../../../settings/application/settings_application.dart';
import '../../domain/onboarding_domain.dart';
import '../starter_template_loader.dart';
import 'create_starter_groups.dart';

final class CompleteOnboarding {
  const CompleteOnboarding({
    required this.loadSettingsProfile,
    required this.saveSettingsProfile,
    required this.onboardingStatusRepository,
    required this.createStarterGroups,
    required this.starterTemplateLoader,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final LoadSettingsProfile loadSettingsProfile;
  final SaveSettingsProfile saveSettingsProfile;
  final OnboardingStatusRepository onboardingStatusRepository;
  final CreateStarterGroups createStarterGroups;
  final StarterTemplateLoader starterTemplateLoader;
  final DateTime Function() _now;

  Future<OnboardingStatus> call(OnboardingDraft draft) async {
    final currentSettings = await loadSettingsProfile();
    await saveSettingsProfile(draft.applyTo(currentSettings));

    if (draft.createStarterGroups) {
      final catalog = await starterTemplateLoader.load();
      await createStarterGroups(catalog);
    }

    final status = OnboardingStatus(
      completion: OnboardingCompletion.completed,
      updatedAt: _now().toUtc(),
    );
    await onboardingStatusRepository.save(status);
    return status;
  }
}
