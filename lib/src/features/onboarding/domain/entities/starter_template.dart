import '../../../training_log/domain/training_log_domain.dart';
import '../../../workout_groups/domain/workout_groups_domain.dart';
import '../exceptions/onboarding_validation_exception.dart';

final class StarterTemplateCatalog {
  StarterTemplateCatalog({
    required this.templateVersion,
    required Iterable<StarterGroupTemplate> groups,
  }) : groups = List<StarterGroupTemplate>.unmodifiable(_requireGroups(groups));

  final String templateVersion;
  final List<StarterGroupTemplate> groups;
}

final class StarterGroupTemplate {
  StarterGroupTemplate({
    required this.id,
    required this.name,
    required Iterable<StarterExerciseTemplate> exercises,
  }) : exercises = List<StarterExerciseTemplate>.unmodifiable(
         _requireExercises(exercises),
       );

  final String id;
  final String name;
  final List<StarterExerciseTemplate> exercises;
}

final class StarterExerciseTemplate {
  const StarterExerciseTemplate({
    required this.catalogId,
    required this.displayNameSnapshot,
    required this.catalogVersionSnapshot,
  });

  final String catalogId;
  final String displayNameSnapshot;
  final String catalogVersionSnapshot;

  ExerciseRef toExerciseRef() {
    return ExerciseRef.official(
      id: OfficialExerciseId(catalogId),
      displayNameSnapshot: displayNameSnapshot,
      catalogVersionSnapshot: catalogVersionSnapshot,
    );
  }
}

List<StarterGroupTemplate> _requireGroups(
  Iterable<StarterGroupTemplate> groups,
) {
  final list = groups.toList(growable: false);
  if (list.isEmpty) {
    throw const OnboardingValidationException(
      'groups',
      'Starter templates must include at least one group.',
    );
  }
  return list;
}

List<StarterExerciseTemplate> _requireExercises(
  Iterable<StarterExerciseTemplate> exercises,
) {
  final list = exercises.toList(growable: false);
  if (list.isEmpty) {
    throw const OnboardingValidationException(
      'exercises',
      'Starter group templates must include at least one exercise.',
    );
  }
  return list;
}

WorkoutGroup groupFromTemplate(StarterGroupTemplate template, int sortOrder) {
  return WorkoutGroup(
    id: WorkoutGroupId('starter_${template.id}'),
    name: WorkoutGroupName(template.name),
    sortOrder: WorkoutGroupSortOrder(sortOrder),
  );
}

WorkoutGroupExerciseAssignment assignmentFromTemplate({
  required StarterGroupTemplate group,
  required StarterExerciseTemplate exercise,
  required int position,
}) {
  return WorkoutGroupExerciseAssignment(
    id: WorkoutGroupExerciseAssignmentId(
      'starter_${group.id}_${exercise.catalogId}',
    ),
    workoutGroupId: WorkoutGroupId('starter_${group.id}'),
    exerciseRef: exercise.toExerciseRef(),
    position: AssignmentPosition(position),
  );
}
