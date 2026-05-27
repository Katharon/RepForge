import 'catalog_validation.dart';

final class EquipmentTag {
  EquipmentTag(String value)
    : value = requireCatalogText('equipmentTag', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is EquipmentTag && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class MuscleGroup {
  MuscleGroup(String value) : value = requireCatalogText('muscleGroup', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is MuscleGroup && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class MovementPattern {
  MovementPattern(String value)
    : value = requireCatalogText('movementPattern', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is MovementPattern && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
