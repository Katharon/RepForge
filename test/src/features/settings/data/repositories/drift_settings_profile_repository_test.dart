import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/settings/data/repositories/drift_settings_profile_repository.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;
  late DriftSettingsProfileRepository repository;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
    repository = DriftSettingsProfileRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('loads deterministic defaults when no settings row exists', () async {
    expect(await repository.load(), SettingsProfile.defaults());
  });

  test('saves and loads profile settings and structured equipment', () async {
    final profile = SettingsProfile.defaults().copyWith(
      languageOverride: LanguageOverride.german,
      unitPreference: UnitPreference.imperial,
      themePreference: ThemePreference.dark,
      defaultRestTime: DefaultRestTime.seconds(120),
      userProfile: UserProfile(displayName: 'Luki'),
      focusProfile: FocusProfile.strengthBasics,
      trainingFrequency: TrainingFrequency(5),
      sessionDuration: SessionDurationPreference.sixty,
      equipmentInventory: EquipmentInventory(const <AvailableEquipment>[
        AvailableEquipment.barbell,
        AvailableEquipment.bench,
        AvailableEquipment.pullUpBar,
      ]),
    );

    await repository.save(profile);

    expect(await repository.load(), profile);
  });

  test('saving profile replaces equipment inventory only', () async {
    await repository.save(
      SettingsProfile.defaults().copyWith(
        equipmentInventory: EquipmentInventory(const <AvailableEquipment>[
          AvailableEquipment.bodyweight,
          AvailableEquipment.dumbbell,
        ]),
      ),
    );

    await repository.save(
      SettingsProfile.defaults().copyWith(
        equipmentInventory: EquipmentInventory(const <AvailableEquipment>[
          AvailableEquipment.cable,
        ]),
      ),
    );

    final rows = await database.select(database.equipmentInventoryItems).get();

    expect(rows, hasLength(1));
    expect(rows.single.equipment, 'cable');
  });

  test(
    'settings persistence does not touch workout sets or catalog rows',
    () async {
      await database
          .into(database.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              workoutSetId: 'set-1',
              exerciseSource: 'official',
              exerciseId: 'barbell_bench_press',
              exerciseDisplayNameSnapshot: 'Bench Press',
              catalogVersionSnapshot: const Value<String?>('2026.05.0'),
              repetitions: 5,
              loadKg: 100,
              performedAt: DateTime.utc(2026, 5, 28, 12),
            ),
          );
      await database
          .into(database.officialExercises)
          .insert(
            OfficialExercisesCompanion.insert(
              catalogId: 'barbell_bench_press',
              catalogVersion: '2026.05.0',
              schemaVersion: 1,
              englishName: 'Bench Press',
              germanName: 'Bankdruecken',
            ),
          );

      await repository.save(SettingsProfile.defaults());

      expect(await database.select(database.workoutSets).get(), hasLength(1));
      expect(
        await database.select(database.officialExercises).get(),
        hasLength(1),
      );
    },
  );
}
