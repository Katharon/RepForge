import 'stable_ids.dart';
import 'training_log_validation.dart';

enum ExerciseSource { official, custom }

final class ExerciseRef {
  ExerciseRef._({
    required this.source,
    required String id,
    required String displayNameSnapshot,
    this.catalogVersionSnapshot,
  }) : id = requireNonBlank('exerciseRef.id', id),
       displayNameSnapshot = requireNonBlank(
         'exerciseRef.displayNameSnapshot',
         displayNameSnapshot,
       );

  factory ExerciseRef.official({
    required OfficialExerciseId id,
    required String displayNameSnapshot,
    String? catalogVersionSnapshot,
  }) {
    return ExerciseRef._(
      source: ExerciseSource.official,
      id: id.value,
      displayNameSnapshot: displayNameSnapshot,
      catalogVersionSnapshot: catalogVersionSnapshot == null
          ? null
          : requireNonBlank(
              'exerciseRef.catalogVersionSnapshot',
              catalogVersionSnapshot,
            ),
    );
  }

  factory ExerciseRef.custom({
    required CustomExerciseId id,
    required String displayNameSnapshot,
  }) {
    return ExerciseRef._(
      source: ExerciseSource.custom,
      id: id.value,
      displayNameSnapshot: displayNameSnapshot,
    );
  }

  final ExerciseSource source;
  final String id;
  final String displayNameSnapshot;
  final String? catalogVersionSnapshot;

  @override
  bool operator ==(Object other) {
    return other is ExerciseRef &&
        other.source == source &&
        other.id == id &&
        other.displayNameSnapshot == displayNameSnapshot &&
        other.catalogVersionSnapshot == catalogVersionSnapshot;
  }

  @override
  int get hashCode {
    return Object.hash(source, id, displayNameSnapshot, catalogVersionSnapshot);
  }
}
