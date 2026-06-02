import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/recovery/data/recovery_data.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;
  late DriftReadinessCheckInRepository repository;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
    repository = DriftReadinessCheckInRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('save and load latest check-in roundtrip', () async {
    final checkIn = _checkIn(
      id: 'check-in-1',
      checkedInAt: DateTime.utc(2026, 6, 2, 8),
    );

    await repository.save(checkIn);

    expect(await repository.latest(), checkIn);
  });

  test('latest uses timestamp then stable id ordering', () async {
    await repository.save(
      _checkIn(id: 'a-earlier', checkedInAt: DateTime.utc(2026, 6, 2, 8)),
    );
    await repository.save(
      _checkIn(id: 'b-later', checkedInAt: DateTime.utc(2026, 6, 2, 9)),
    );

    expect((await repository.latest())?.id, ReadinessCheckInId('b-later'));
  });

  test('date filtering returns only check-ins inside the range', () async {
    await repository.save(
      _checkIn(id: 'yesterday', checkedInAt: DateTime.utc(2026, 6, 1, 20)),
    );
    await repository.save(
      _checkIn(id: 'today', checkedInAt: DateTime.utc(2026, 6, 2, 7)),
    );

    final latest = await repository.latestForRange(
      startInclusive: DateTime.utc(2026, 6, 2),
      endExclusive: DateTime.utc(2026, 6, 3),
    );

    expect(latest?.id, ReadinessCheckInId('today'));
  });

  test(
    'saving check-ins does not mutate workout sets catalog groups or profile',
    () async {
      await database
          .into(database.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              workoutSetId: 'set-1',
              exerciseSource: 'official',
              exerciseId: 'barbell-bench-press',
              exerciseDisplayNameSnapshot: 'Barbell Bench Press',
              catalogVersionSnapshot: const Value<String?>('2026.05.0'),
              repetitions: 5,
              loadKg: 100,
              performedAt: DateTime.utc(2026, 6, 2, 10),
            ),
          );
      await database
          .into(database.officialExercises)
          .insert(
            OfficialExercisesCompanion.insert(
              catalogId: 'barbell-bench-press',
              catalogVersion: '2026.05.0',
              schemaVersion: 1,
              englishName: 'Barbell Bench Press',
              germanName: 'Bankdruecken',
            ),
          );
      await database
          .into(database.workoutGroups)
          .insert(
            WorkoutGroupsCompanion.insert(
              workoutGroupId: 'group-1',
              name: 'Push Day',
              sortOrder: 0,
            ),
          );
      await database
          .into(database.settingsProfiles)
          .insert(
            SettingsProfilesCompanion.insert(
              profileId: 'local',
              languageOverride: 'system',
              unitPreference: 'metric',
              themePreference: 'system',
              defaultRestSeconds: 90,
              focusProfile: 'balanced',
              trainingDaysPerWeek: 3,
              sessionDurationMinutes: 45,
            ),
          );

      await repository.save(
        _checkIn(id: 'check-in-1', checkedInAt: DateTime.utc(2026, 6, 2, 8)),
      );

      expect(await database.select(database.workoutSets).get(), hasLength(1));
      expect(
        await database.select(database.officialExercises).get(),
        hasLength(1),
      );
      expect(await database.select(database.workoutGroups).get(), hasLength(1));
      expect(
        await database.select(database.settingsProfiles).get(),
        hasLength(1),
      );
    },
  );
}

ReadinessCheckIn _checkIn({required String id, required DateTime checkedInAt}) {
  return ReadinessCheckIn(
    id: ReadinessCheckInId(id),
    checkedInAt: checkedInAt,
    soreness: SorenessRating.moderate(),
    sleepQuality: SleepQualityRating(4),
    energy: EnergyRating(4),
    stress: StressRating(2),
    motivation: MotivationRating(4),
  );
}
