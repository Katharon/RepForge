import '../../domain/settings_domain.dart';

final class ValidateEquipmentInventory {
  const ValidateEquipmentInventory();

  EquipmentInventory call(EquipmentInventory inventory) {
    return EquipmentInventory(
      inventory.items,
      loadConstraints: inventory.loadConstraints,
    );
  }
}
