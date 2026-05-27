import '../../domain/training_log_domain.dart';
import '../forms/workout_set_form.dart';

final class UpdateWorkoutSet {
  const UpdateWorkoutSet(this._repository);

  final WorkoutSetRepository _repository;

  Future<WorkoutSet> call(WorkoutSetForm form) async {
    final id = form.existingWorkoutSetId;
    if (id == null) {
      throw const TrainingLogValidationException(
        'workoutSetId',
        'Existing workout set id is required for edits.',
      );
    }

    final existing = await _repository.findById(id);
    if (existing == null) {
      throw StateError('Workout set not found: ${id.value}');
    }

    final updated = form.applyToExisting(existing);
    await _repository.save(updated);
    return updated;
  }
}
