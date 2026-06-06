import '../../../training_log/domain/value_objects/stable_ids.dart';
import '../value_objects/catalog_tags.dart';
import '../value_objects/catalog_validation.dart';

final class CustomExercise {
  CustomExercise({
    required this.id,
    required String name,
    required Iterable<MuscleGroup> primaryMuscles,
    Iterable<MuscleGroup> secondaryMuscles = const <MuscleGroup>[],
    Iterable<EquipmentTag> equipment = const <EquipmentTag>[],
    Iterable<MovementPattern> movementPatterns = const <MovementPattern>[],
    String? notes,
    DateTime? archivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : name = requireCatalogText('customExercise.name', name),
       notes = _normalizeOptionalText('customExercise.notes', notes),
       primaryMuscles = requireCatalogItems(
         'customExercise.primaryMuscles',
         primaryMuscles,
       ),
       secondaryMuscles = List<MuscleGroup>.unmodifiable(secondaryMuscles),
       equipment = List<EquipmentTag>.unmodifiable(equipment),
       movementPatterns = List<MovementPattern>.unmodifiable(movementPatterns),
       archivedAt = archivedAt?.toUtc(),
       createdAt = (createdAt ?? DateTime.now()).toUtc(),
       updatedAt = (updatedAt ?? createdAt ?? DateTime.now()).toUtc();

  final CustomExerciseId id;
  final String name;
  final String? notes;
  final List<MuscleGroup> primaryMuscles;
  final List<MuscleGroup> secondaryMuscles;
  final List<EquipmentTag> equipment;
  final List<MovementPattern> movementPatterns;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isArchived => archivedAt != null;

  @override
  bool operator ==(Object other) {
    return other is CustomExercise &&
        other.id == id &&
        other.name == name &&
        other.notes == notes &&
        _listEquals(other.primaryMuscles, primaryMuscles) &&
        _listEquals(other.secondaryMuscles, secondaryMuscles) &&
        _listEquals(other.equipment, equipment) &&
        _listEquals(other.movementPatterns, movementPatterns) &&
        other.archivedAt == archivedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      notes,
      Object.hashAll(primaryMuscles),
      Object.hashAll(secondaryMuscles),
      Object.hashAll(equipment),
      Object.hashAll(movementPatterns),
      archivedAt,
      createdAt,
      updatedAt,
    );
  }
}

String? _normalizeOptionalText(String field, String? value) {
  if (value == null) {
    return null;
  }
  final normalized = value.trim();
  if (normalized.isEmpty) {
    return null;
  }
  return requireCatalogText(field, normalized);
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}
