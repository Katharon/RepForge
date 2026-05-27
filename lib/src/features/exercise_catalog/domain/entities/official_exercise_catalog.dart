import '../value_objects/catalog_validation.dart';
import '../value_objects/catalog_version.dart';
import 'official_exercise.dart';

final class OfficialExerciseCatalog {
  OfficialExerciseCatalog({
    required this.catalogVersion,
    required this.schemaVersion,
    required Iterable<OfficialExercise> exercises,
  }) : exercises = requireCatalogItems(
         'officialExerciseCatalog.exercises',
         exercises,
       );

  final CatalogVersion catalogVersion;
  final int schemaVersion;
  final List<OfficialExercise> exercises;
}
