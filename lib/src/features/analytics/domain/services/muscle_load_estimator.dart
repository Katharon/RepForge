import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import '../exceptions/analytics_validation_exception.dart';
import '../value_objects/muscle_activation.dart';

final class MuscleLoadEstimator {
  const MuscleLoadEstimator();

  MuscleLoadEstimate estimate({
    required Iterable<MuscleLoadInput> inputs,
    required Iterable<ExerciseActivationProfile> profiles,
  }) {
    final profileLookup = _profileLookup(profiles);
    final loadByMuscle = <MuscleId, double>{};
    final unknownExercises = <_ExerciseProfileKey, MuscleLoadInput>{};
    var hasConservativeInput = false;

    for (final input in inputs) {
      final profileKey = _ExerciseProfileKey.fromRef(input.set.exerciseRef);
      final profile = profileLookup[profileKey];

      if (profile == null ||
          profile.state == ExerciseActivationProfileState.unavailable) {
        unknownExercises.putIfAbsent(profileKey, () => input);
        continue;
      }

      if (profile.confidence == MuscleLoadConfidence.conservative ||
          input.effectiveLoadState == MuscleLoadInputLoadState.incomplete) {
        hasConservativeInput = true;
      }

      final setVolumeKg = input.set.load.value * input.set.repetitions.value;
      for (final entry in profile.entries) {
        loadByMuscle.update(
          entry.muscleId,
          (current) => current + setVolumeKg * entry.weight.value,
          ifAbsent: () => setVolumeKg * entry.weight.value,
        );
      }
    }

    final muscleLoads =
        loadByMuscle.entries
            .map(
              (entry) =>
                  MuscleLoad(muscleId: entry.key, estimatedLoadKg: entry.value),
            )
            .toList()
          ..sort(
            (left, right) =>
                left.muscleId.value.compareTo(right.muscleId.value),
          );

    final confidence = unknownExercises.isNotEmpty
        ? MuscleLoadConfidence.unavailable
        : hasConservativeInput
        ? MuscleLoadConfidence.conservative
        : MuscleLoadConfidence.estimated;

    return MuscleLoadEstimate(
      muscleLoads: muscleLoads,
      unknownExercises: unknownExercises.values
          .map((input) => input.set.exerciseRef)
          .toList(),
      confidence: confidence,
    );
  }

  Map<_ExerciseProfileKey, ExerciseActivationProfile> _profileLookup(
    Iterable<ExerciseActivationProfile> profiles,
  ) {
    final lookup = <_ExerciseProfileKey, ExerciseActivationProfile>{};
    for (final profile in profiles) {
      final key = _ExerciseProfileKey(
        exerciseSource: profile.exerciseSource,
        exerciseId: profile.exerciseId,
      );
      if (lookup.containsKey(key)) {
        throw AnalyticsValidationException(
          'exerciseActivationProfiles',
          'Duplicate activation profile for ${profile.exerciseSource.name}:${profile.exerciseId}.',
        );
      }
      lookup[key] = profile;
    }

    return lookup;
  }
}

final class _ExerciseProfileKey {
  const _ExerciseProfileKey({
    required this.exerciseSource,
    required this.exerciseId,
  });

  factory _ExerciseProfileKey.fromRef(ExerciseRef exerciseRef) {
    return _ExerciseProfileKey(
      exerciseSource: exerciseRef.source,
      exerciseId: exerciseRef.id,
    );
  }

  final ExerciseSource exerciseSource;
  final String exerciseId;

  @override
  bool operator ==(Object other) {
    return other is _ExerciseProfileKey &&
        other.exerciseSource == exerciseSource &&
        other.exerciseId == exerciseId;
  }

  @override
  int get hashCode => Object.hash(exerciseSource, exerciseId);
}
