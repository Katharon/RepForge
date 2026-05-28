import '../../../../shared/data/local/repforge_database.dart';
import '../../domain/onboarding_domain.dart';

const onboardingStatusStorageId = 'local';

final class OnboardingStatusMapper {
  const OnboardingStatusMapper._();

  static OnboardingStatusesCompanion toCompanion(OnboardingStatus status) {
    return OnboardingStatusesCompanion.insert(
      statusId: onboardingStatusStorageId,
      completion: _completionToStorage(status.completion),
      updatedAt: status.updatedAt ?? DateTime.now().toUtc(),
    );
  }

  static OnboardingStatus toDomain(OnboardingStatusRow row) {
    return OnboardingStatus(
      completion: _completionFromStorage(row.completion),
      updatedAt: row.updatedAt.toUtc(),
    );
  }
}

String _completionToStorage(OnboardingCompletion value) {
  return switch (value) {
    OnboardingCompletion.notStarted => 'notStarted',
    OnboardingCompletion.skipped => 'skipped',
    OnboardingCompletion.completed => 'completed',
  };
}

OnboardingCompletion _completionFromStorage(String value) {
  return switch (value) {
    'notStarted' => OnboardingCompletion.notStarted,
    'skipped' => OnboardingCompletion.skipped,
    'completed' => OnboardingCompletion.completed,
    _ => throw OnboardingValidationException(
      'completion',
      'Unsupported persisted onboarding completion.',
    ),
  };
}
