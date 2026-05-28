import '../exceptions/settings_validation_exception.dart';
import 'settings_enums.dart';

final class EquipmentInventory {
  EquipmentInventory(Iterable<AvailableEquipment> items)
    : items = Set<AvailableEquipment>.unmodifiable(_validate(items));

  factory EquipmentInventory.defaults() {
    return EquipmentInventory(const <AvailableEquipment>[
      AvailableEquipment.bodyweight,
    ]);
  }

  final Set<AvailableEquipment> items;

  bool contains(AvailableEquipment equipment) => items.contains(equipment);

  @override
  bool operator ==(Object other) {
    return other is EquipmentInventory &&
        other.items.length == items.length &&
        other.items.containsAll(items);
  }

  @override
  int get hashCode => Object.hashAllUnordered(items);
}

Set<AvailableEquipment> _validate(Iterable<AvailableEquipment> items) {
  final normalized = Set<AvailableEquipment>.of(items);
  if (normalized.isEmpty) {
    throw const SettingsValidationException(
      'equipmentInventory',
      'Must include at least one equipment option.',
    );
  }
  return normalized;
}
