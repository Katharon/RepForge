import '../exceptions/settings_validation_exception.dart';
import 'settings_enums.dart';

final class EquipmentInventory {
  EquipmentInventory(
    Iterable<AvailableEquipment> items, {
    Map<AvailableEquipment, EquipmentLoadConstraint> loadConstraints =
        const <AvailableEquipment, EquipmentLoadConstraint>{},
  }) : items = Set<AvailableEquipment>.unmodifiable(_validate(items)),
       loadConstraints =
           Map<AvailableEquipment, EquipmentLoadConstraint>.unmodifiable(
             _validateConstraints(items, loadConstraints),
           );

  factory EquipmentInventory.defaults() {
    return EquipmentInventory(const <AvailableEquipment>[
      AvailableEquipment.bodyweight,
    ]);
  }

  final Set<AvailableEquipment> items;
  final Map<AvailableEquipment, EquipmentLoadConstraint> loadConstraints;

  bool contains(AvailableEquipment equipment) => items.contains(equipment);

  EquipmentLoadConstraint? loadConstraintFor(AvailableEquipment equipment) {
    return loadConstraints[equipment];
  }

  @override
  bool operator ==(Object other) {
    return other is EquipmentInventory &&
        other.items.length == items.length &&
        other.items.containsAll(items) &&
        other.loadConstraints.length == loadConstraints.length &&
        _mapEquals(other.loadConstraints, loadConstraints);
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAllUnordered(items),
      Object.hashAll(
        loadConstraints.entries.map((entry) {
          return Object.hash(entry.key, entry.value);
        }),
      ),
    );
  }
}

final class EquipmentLoadConstraint {
  EquipmentLoadConstraint({this.maxLoadKg, this.incrementKg}) {
    if (maxLoadKg == null && incrementKg == null) {
      throw const SettingsValidationException(
        'equipmentLoadConstraint',
        'Must include a max load or increment.',
      );
    }
    final maxLoad = maxLoadKg;
    final increment = incrementKg;
    if (maxLoad != null &&
        increment != null &&
        increment.value > maxLoad.value) {
      throw const SettingsValidationException(
        'incrementKg',
        'Must not be greater than max load.',
      );
    }
  }

  final MaxLoadKg? maxLoadKg;
  final LoadIncrementKg? incrementKg;

  @override
  bool operator ==(Object other) {
    return other is EquipmentLoadConstraint &&
        other.maxLoadKg == maxLoadKg &&
        other.incrementKg == incrementKg;
  }

  @override
  int get hashCode => Object.hash(maxLoadKg, incrementKg);
}

final class MaxLoadKg {
  MaxLoadKg(this.value) {
    if (!value.isFinite || value <= 0 || value > 1000) {
      throw const SettingsValidationException(
        'maxLoadKg',
        'Must be greater than zero and 1000 kg or less.',
      );
    }
  }

  final double value;

  @override
  bool operator ==(Object other) {
    return other is MaxLoadKg && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class LoadIncrementKg {
  LoadIncrementKg(this.value) {
    if (!value.isFinite || value <= 0 || value > 100) {
      throw const SettingsValidationException(
        'incrementKg',
        'Must be greater than zero and 100 kg or less.',
      );
    }
  }

  final double value;

  @override
  bool operator ==(Object other) {
    return other is LoadIncrementKg && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
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

Map<AvailableEquipment, EquipmentLoadConstraint> _validateConstraints(
  Iterable<AvailableEquipment> items,
  Map<AvailableEquipment, EquipmentLoadConstraint> loadConstraints,
) {
  final normalizedItems = Set<AvailableEquipment>.of(items);
  for (final equipment in loadConstraints.keys) {
    if (!normalizedItems.contains(equipment)) {
      throw const SettingsValidationException(
        'equipmentLoadConstraints',
        'Load constraints must belong to selected equipment.',
      );
    }
  }
  return loadConstraints;
}

bool _mapEquals(
  Map<AvailableEquipment, EquipmentLoadConstraint> left,
  Map<AvailableEquipment, EquipmentLoadConstraint> right,
) {
  for (final entry in left.entries) {
    if (right[entry.key] != entry.value) {
      return false;
    }
  }
  return true;
}
