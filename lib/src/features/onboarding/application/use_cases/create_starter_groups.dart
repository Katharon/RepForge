import '../../../workout_groups/domain/workout_groups_domain.dart';
import '../../domain/onboarding_domain.dart';

final class CreateStarterGroups {
  const CreateStarterGroups(this._repository);

  final WorkoutGroupRepository _repository;

  Future<void> call(StarterTemplateCatalog catalog) async {
    for (var groupIndex = 0; groupIndex < catalog.groups.length; groupIndex++) {
      final groupTemplate = catalog.groups[groupIndex];
      await _repository.saveGroup(groupFromTemplate(groupTemplate, groupIndex));

      for (
        var exerciseIndex = 0;
        exerciseIndex < groupTemplate.exercises.length;
        exerciseIndex++
      ) {
        await _repository.saveAssignment(
          assignmentFromTemplate(
            group: groupTemplate,
            exercise: groupTemplate.exercises[exerciseIndex],
            position: exerciseIndex,
          ),
        );
      }
    }
  }
}
