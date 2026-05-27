import '../../../training_log/domain/value_objects/stable_ids.dart';
import '../entities/official_exercise.dart';
import '../value_objects/exercise_catalog_page.dart';
import '../value_objects/exercise_catalog_query.dart';

abstract interface class ExerciseCatalogRepository {
  Future<ExerciseCatalogPage> findOfficialExercises(ExerciseCatalogQuery query);

  Future<OfficialExercise?> findOfficialExerciseById(OfficialExerciseId id);
}
