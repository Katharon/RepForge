import '../../domain/training_log_domain.dart';

final class DeleteWorkoutSet {
  const DeleteWorkoutSet(this._repository);

  final WorkoutSetRepository _repository;

  Future<void> call(WorkoutSetId workoutSetId) {
    return _repository.deleteById(workoutSetId);
  }
}
