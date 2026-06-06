import '../../../training_log/domain/value_objects/stable_ids.dart';
import '../entities/custom_exercise.dart';
import '../value_objects/custom_exercise_page.dart';
import '../value_objects/custom_exercise_query.dart';

abstract interface class CustomExerciseRepository {
  Future<void> saveCustomExercise(CustomExercise exercise);

  Future<CustomExercise?> findCustomExerciseById(CustomExerciseId id);

  Future<CustomExercisePage> listCustomExercises(CustomExerciseQuery query);

  Future<void> archiveCustomExercise(CustomExerciseId id, DateTime archivedAt);
}
