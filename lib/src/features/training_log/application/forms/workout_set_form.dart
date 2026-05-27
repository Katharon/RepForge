import '../../domain/training_log_domain.dart';

final class WorkoutSetForm {
  const WorkoutSetForm({
    required this.targetExerciseRef,
    required this.loadKgInput,
    required this.repetitionsInput,
    required this.performedAt,
    this.existingWorkoutSetId,
    this.commentInput,
  });

  final WorkoutSetId? existingWorkoutSetId;
  final ExerciseRef targetExerciseRef;
  final String loadKgInput;
  final String repetitionsInput;
  final DateTime performedAt;
  final String? commentInput;

  WorkoutSet toNewWorkoutSet({
    required WorkoutSetId workoutSetId,
    WorkoutSessionId? workoutSessionId,
  }) {
    return WorkoutSet(
      id: workoutSetId,
      exerciseRef: targetExerciseRef,
      workoutSessionId: workoutSessionId,
      repetitions: _parseRepetitions(),
      load: _parseLoad(),
      performedAt: PerformedAt(performedAt),
      comment: _parseComment(),
    );
  }

  WorkoutSet applyToExisting(WorkoutSet existing) {
    return WorkoutSet(
      id: existing.id,
      exerciseRef: existing.exerciseRef,
      workoutSessionId: existing.workoutSessionId,
      repetitions: _parseRepetitions(),
      load: _parseLoad(),
      performedAt: PerformedAt(performedAt),
      comment: _parseComment(),
    );
  }

  Repetitions _parseRepetitions() {
    final value = int.tryParse(repetitionsInput.trim());
    if (value == null) {
      throw const TrainingLogValidationException(
        'repetitions',
        'Must be a whole number.',
      );
    }

    return Repetitions(value);
  }

  LoadKg _parseLoad() {
    final value = num.tryParse(loadKgInput.trim());
    if (value == null) {
      throw const TrainingLogValidationException('loadKg', 'Must be a number.');
    }

    return LoadKg(value);
  }

  SetComment? _parseComment() {
    final comment = commentInput;
    if (comment == null || comment.trim().isEmpty) {
      return null;
    }

    return SetComment(comment);
  }
}
