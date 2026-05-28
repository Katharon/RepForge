import '../entities/workout_set.dart';
import '../value_objects/exercise_ref.dart';
import '../value_objects/stable_ids.dart';
import '../value_objects/workout_set_history_query.dart';
import '../value_objects/workout_set_timeline.dart';

abstract interface class WorkoutSetRepository {
  Future<void> save(WorkoutSet set);

  Future<void> deleteById(WorkoutSetId id);

  Future<WorkoutSet?> findById(WorkoutSetId id);

  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef);

  Future<WorkoutSetHistoryPage> searchHistory(WorkoutSetHistoryQuery query);

  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  );

  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  );
}
