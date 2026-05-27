import '../../../training_log/domain/value_objects/stable_ids.dart';
import '../value_objects/catalog_tags.dart';
import '../value_objects/catalog_validation.dart';
import '../value_objects/catalog_version.dart';

final class OfficialExercise {
  OfficialExercise({
    required this.id,
    required this.catalogVersion,
    required String englishName,
    required String germanName,
    required Iterable<EquipmentTag> equipment,
    required Iterable<MovementPattern> movementPatterns,
    required Iterable<MuscleGroup> primaryMuscles,
    Iterable<MuscleGroup> secondaryMuscles = const <MuscleGroup>[],
  }) : englishName = requireCatalogText(
         'officialExercise.englishName',
         englishName,
       ),
       germanName = requireCatalogText(
         'officialExercise.germanName',
         germanName,
       ),
       equipment = requireCatalogItems('officialExercise.equipment', equipment),
       movementPatterns = requireCatalogItems(
         'officialExercise.movementPatterns',
         movementPatterns,
       ),
       primaryMuscles = requireCatalogItems(
         'officialExercise.primaryMuscles',
         primaryMuscles,
       ),
       secondaryMuscles = List<MuscleGroup>.unmodifiable(secondaryMuscles);

  final OfficialExerciseId id;
  final CatalogVersion catalogVersion;
  final String englishName;
  final String germanName;
  final List<EquipmentTag> equipment;
  final List<MovementPattern> movementPatterns;
  final List<MuscleGroup> primaryMuscles;
  final List<MuscleGroup> secondaryMuscles;

  List<MuscleGroup> get allMuscles {
    return <MuscleGroup>[...primaryMuscles, ...secondaryMuscles];
  }

  @override
  bool operator ==(Object other) {
    return other is OfficialExercise &&
        other.id == id &&
        other.catalogVersion == catalogVersion &&
        other.englishName == englishName &&
        other.germanName == germanName &&
        _listEquals(other.equipment, equipment) &&
        _listEquals(other.movementPatterns, movementPatterns) &&
        _listEquals(other.primaryMuscles, primaryMuscles) &&
        _listEquals(other.secondaryMuscles, secondaryMuscles);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      catalogVersion,
      englishName,
      germanName,
      Object.hashAll(equipment),
      Object.hashAll(movementPatterns),
      Object.hashAll(primaryMuscles),
      Object.hashAll(secondaryMuscles),
    );
  }
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
