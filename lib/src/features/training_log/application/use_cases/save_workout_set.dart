import '../../domain/training_log_domain.dart';
import '../forms/workout_set_form.dart';

final class SaveWorkoutSet {
  const SaveWorkoutSet(this._repository);

  final WorkoutSetRepository _repository;

  Future<WorkoutSet> call(
    WorkoutSetForm form, {
    required WorkoutSetId workoutSetId,
    WorkoutSessionId? workoutSessionId,
  }) async {
    final set = form.toNewWorkoutSet(
      workoutSetId: workoutSetId,
      workoutSessionId: workoutSessionId,
    );
    await _repository.save(set);
    return set;
  }
}
