import 'package:drift/drift.dart';

import '../../../../shared/data/local/repforge_database.dart';
import '../../domain/settings_domain.dart';
import '../mappers/settings_profile_mapper.dart';

final class DriftSettingsProfileRepository
    implements SettingsProfileRepository {
  const DriftSettingsProfileRepository(this._database);

  final RepForgeDatabase _database;

  @override
  Future<SettingsProfile> load() async {
    final rows =
        await (_database.select(_database.settingsProfiles)
              ..where(($SettingsProfilesTable table) {
                return table.profileId.equals(settingsProfileStorageId);
              }))
            .get();

    if (rows.isEmpty) {
      return SettingsProfile.defaults();
    }

    final equipmentRows =
        await (_database.select(_database.equipmentInventoryItems)
              ..where(($EquipmentInventoryItemsTable table) {
                return table.profileId.equals(settingsProfileStorageId);
              })
              ..orderBy([
                ($EquipmentInventoryItemsTable table) =>
                    OrderingTerm.asc(table.equipment),
              ]))
            .get();

    if (equipmentRows.isEmpty) {
      return SettingsProfileMapper.toDomain(
        row: rows.single,
        equipmentRows: SettingsProfile.defaults().equipmentInventory.items
            .map(SettingsProfileMapper.toEquipmentCompanion)
            .map(
              (companion) => EquipmentInventoryItemRow(
                profileId: companion.profileId.value,
                equipment: companion.equipment.value,
              ),
            )
            .toList(growable: false),
      );
    }

    return SettingsProfileMapper.toDomain(
      row: rows.single,
      equipmentRows: equipmentRows,
    );
  }

  @override
  Future<void> save(SettingsProfile profile) async {
    await _database.transaction(() async {
      await _database
          .into(_database.settingsProfiles)
          .insertOnConflictUpdate(
            SettingsProfileMapper.toProfileCompanion(profile),
          );

      await (_database.delete(_database.equipmentInventoryItems)
            ..where(($EquipmentInventoryItemsTable table) {
              return table.profileId.equals(settingsProfileStorageId);
            }))
          .go();

      for (final equipment in profile.equipmentInventory.items) {
        await _database
            .into(_database.equipmentInventoryItems)
            .insert(SettingsProfileMapper.toEquipmentCompanion(equipment));
      }
    });
  }
}
