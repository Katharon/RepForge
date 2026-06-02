import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import '../exceptions/analytics_validation_exception.dart';

enum MuscleLoadConfidence { estimated, conservative, unavailable }

enum ExerciseActivationProfileState { known, unavailable }

enum MuscleLoadInputLoadState { logged, incomplete }

final class MuscleId {
  MuscleId(String value) : value = _requireNonBlank('muscleId', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is MuscleId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class ActivationWeight {
  ActivationWeight(num value)
    : value = _requireBoundedFinite('activationWeight', value);

  final double value;

  @override
  bool operator ==(Object other) {
    return other is ActivationWeight && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

final class MuscleActivationEntry {
  const MuscleActivationEntry({required this.muscleId, required this.weight});

  final MuscleId muscleId;
  final ActivationWeight weight;

  @override
  bool operator ==(Object other) {
    return other is MuscleActivationEntry &&
        other.muscleId == muscleId &&
        other.weight == weight;
  }

  @override
  int get hashCode => Object.hash(muscleId, weight);
}

final class ExerciseActivationProfile {
  ExerciseActivationProfile._({
    required this.exerciseSource,
    required String exerciseId,
    required Iterable<MuscleActivationEntry> entries,
    required this.state,
    required this.confidence,
  }) : exerciseId = _requireNonBlank(
         'exerciseActivationProfile.exerciseId',
         exerciseId,
       ),
       entries = _requireEntries(state, entries);

  factory ExerciseActivationProfile.known({
    required ExerciseSource exerciseSource,
    required String exerciseId,
    required Iterable<MuscleActivationEntry> entries,
    MuscleLoadConfidence confidence = MuscleLoadConfidence.estimated,
  }) {
    if (confidence == MuscleLoadConfidence.unavailable) {
      throw const AnalyticsValidationException(
        'exerciseActivationProfile.confidence',
        'Known activation profiles must use estimated or conservative confidence.',
      );
    }

    return ExerciseActivationProfile._(
      exerciseSource: exerciseSource,
      exerciseId: exerciseId,
      entries: entries,
      state: ExerciseActivationProfileState.known,
      confidence: confidence,
    );
  }

  factory ExerciseActivationProfile.unavailable({
    required ExerciseSource exerciseSource,
    required String exerciseId,
  }) {
    return ExerciseActivationProfile._(
      exerciseSource: exerciseSource,
      exerciseId: exerciseId,
      entries: const <MuscleActivationEntry>[],
      state: ExerciseActivationProfileState.unavailable,
      confidence: MuscleLoadConfidence.unavailable,
    );
  }

  final ExerciseSource exerciseSource;
  final String exerciseId;
  final List<MuscleActivationEntry> entries;
  final ExerciseActivationProfileState state;
  final MuscleLoadConfidence confidence;

  bool matches(ExerciseRef exerciseRef) {
    return exerciseSource == exerciseRef.source && exerciseId == exerciseRef.id;
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseActivationProfile &&
        other.exerciseSource == exerciseSource &&
        other.exerciseId == exerciseId &&
        _listEquals(other.entries, entries) &&
        other.state == state &&
        other.confidence == confidence;
  }

  @override
  int get hashCode {
    return Object.hash(
      exerciseSource,
      exerciseId,
      Object.hashAll(entries),
      state,
      confidence,
    );
  }
}

final class MuscleLoadInput {
  const MuscleLoadInput({required this.set, this.loadState});

  factory MuscleLoadInput.fromSet(
    WorkoutSet set, {
    MuscleLoadInputLoadState loadState = MuscleLoadInputLoadState.logged,
  }) {
    return MuscleLoadInput(set: set, loadState: loadState);
  }

  final WorkoutSet set;
  final MuscleLoadInputLoadState? loadState;

  MuscleLoadInputLoadState get effectiveLoadState {
    return loadState ?? MuscleLoadInputLoadState.logged;
  }

  @override
  bool operator ==(Object other) {
    return other is MuscleLoadInput &&
        other.set == set &&
        other.effectiveLoadState == effectiveLoadState;
  }

  @override
  int get hashCode => Object.hash(set, effectiveLoadState);
}

final class MuscleLoad {
  MuscleLoad({required this.muscleId, required double estimatedLoadKg})
    : estimatedLoadKg = _requireNonNegativeFinite(
        'muscleLoad.estimatedLoadKg',
        estimatedLoadKg,
      );

  final MuscleId muscleId;
  final double estimatedLoadKg;

  @override
  bool operator ==(Object other) {
    return other is MuscleLoad &&
        other.muscleId == muscleId &&
        other.estimatedLoadKg == estimatedLoadKg;
  }

  @override
  int get hashCode => Object.hash(muscleId, estimatedLoadKg);
}

final class MuscleLoadEstimate {
  MuscleLoadEstimate({
    required Iterable<MuscleLoad> muscleLoads,
    required Iterable<ExerciseRef> unknownExercises,
    required this.confidence,
  }) : muscleLoads = List<MuscleLoad>.unmodifiable(muscleLoads),
       unknownExercises = List<ExerciseRef>.unmodifiable(unknownExercises);

  final List<MuscleLoad> muscleLoads;
  final List<ExerciseRef> unknownExercises;
  final MuscleLoadConfidence confidence;

  double get totalKnownLoadKg {
    return muscleLoads.fold<double>(
      0,
      (total, load) => total + load.estimatedLoadKg,
    );
  }

  MuscleLoad? loadFor(MuscleId muscleId) {
    for (final load in muscleLoads) {
      if (load.muscleId == muscleId) {
        return load;
      }
    }

    return null;
  }

  @override
  bool operator ==(Object other) {
    return other is MuscleLoadEstimate &&
        _listEquals(other.muscleLoads, muscleLoads) &&
        _listEquals(other.unknownExercises, unknownExercises) &&
        other.confidence == confidence;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(muscleLoads),
      Object.hashAll(unknownExercises),
      confidence,
    );
  }
}

List<MuscleActivationEntry> _requireEntries(
  ExerciseActivationProfileState state,
  Iterable<MuscleActivationEntry> entries,
) {
  final immutableEntries = List<MuscleActivationEntry>.unmodifiable(entries);
  if (state == ExerciseActivationProfileState.unavailable) {
    if (immutableEntries.isNotEmpty) {
      throw const AnalyticsValidationException(
        'exerciseActivationProfile.entries',
        'Unavailable activation profiles must not include entries.',
      );
    }

    return immutableEntries;
  }

  if (immutableEntries.isEmpty) {
    throw const AnalyticsValidationException(
      'exerciseActivationProfile.entries',
      'Known activation profiles must include at least one muscle entry.',
    );
  }

  final seenMuscles = <MuscleId>{};
  for (final entry in immutableEntries) {
    if (!seenMuscles.add(entry.muscleId)) {
      throw const AnalyticsValidationException(
        'exerciseActivationProfile.entries',
        'Muscle entries must not contain duplicates.',
      );
    }
  }

  return immutableEntries;
}

String _requireNonBlank(String field, String value) {
  final trimmedValue = value.trim();
  if (trimmedValue.isEmpty) {
    throw AnalyticsValidationException(field, 'Must not be blank.');
  }

  return trimmedValue;
}

double _requireBoundedFinite(String field, num value) {
  if (value.isNaN || value.isInfinite || value < 0 || value > 1) {
    throw AnalyticsValidationException(
      field,
      'Must be a finite value from 0.0 to 1.0.',
    );
  }

  return value.toDouble();
}

double _requireNonNegativeFinite(String field, double value) {
  if (value.isNaN || value.isInfinite || value < 0) {
    throw AnalyticsValidationException(
      field,
      'Must be a finite value greater than or equal to zero.',
    );
  }

  return value;
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }

  return true;
}
