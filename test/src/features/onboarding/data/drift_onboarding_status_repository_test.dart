import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/onboarding/data/onboarding_data.dart';
import 'package:repforge/src/features/onboarding/domain/onboarding_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;
  late DriftOnboardingStatusRepository repository;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
    repository = DriftOnboardingStatusRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('loads not started when no onboarding status exists', () async {
    expect(await repository.load(), OnboardingStatus.notStarted());
  });

  test('saves and loads skipped status', () async {
    final status = OnboardingStatus(
      completion: OnboardingCompletion.skipped,
      updatedAt: DateTime.utc(2026, 5, 28, 12),
    );

    await repository.save(status);

    expect(await repository.load(), status);
  });
}
