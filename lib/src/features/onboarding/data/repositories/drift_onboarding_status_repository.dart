import '../../../../shared/data/local/repforge_database.dart';
import '../../domain/onboarding_domain.dart';
import '../mappers/onboarding_status_mapper.dart';

final class DriftOnboardingStatusRepository
    implements OnboardingStatusRepository {
  const DriftOnboardingStatusRepository(this._database);

  final RepForgeDatabase _database;

  @override
  Future<OnboardingStatus> load() async {
    final row =
        await (_database.select(_database.onboardingStatuses)
              ..where(($OnboardingStatusesTable table) {
                return table.statusId.equals(onboardingStatusStorageId);
              }))
            .getSingleOrNull();

    return row == null
        ? OnboardingStatus.notStarted()
        : OnboardingStatusMapper.toDomain(row);
  }

  @override
  Future<void> save(OnboardingStatus status) async {
    await _database
        .into(_database.onboardingStatuses)
        .insertOnConflictUpdate(OnboardingStatusMapper.toCompanion(status));
  }
}
