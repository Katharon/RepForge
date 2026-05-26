import '../entities/workout_set.dart';
import '../value_objects/exercise_ref.dart';
import '../value_objects/stable_ids.dart';

abstract interface class WorkoutSetRepository {
  Future<void> save(WorkoutSet set);

  Future<WorkoutSet?> findById(WorkoutSetId id);

  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef);

  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  );
}
