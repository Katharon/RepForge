import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../exercise_catalog/presentation/exercise_catalog_presentation.dart';
import 'workout_group_list_loader.dart';

final class WorkoutGroupDraft {
  const WorkoutGroupDraft({required this.name, required this.exercises});

  final String name;
  final List<ExerciseListItemViewModel> exercises;
}

Future<WorkoutGroupDraft?> showWorkoutGroupDialog({
  required BuildContext context,
  required List<ExerciseListItemViewModel> availableExercises,
  WorkoutGroupListItemViewModel? initialGroup,
}) {
  return showDialog<WorkoutGroupDraft>(
    context: context,
    builder: (context) {
      return _WorkoutGroupDialog(
        availableExercises: availableExercises,
        initialGroup: initialGroup,
      );
    },
  );
}

class _WorkoutGroupDialog extends StatefulWidget {
  const _WorkoutGroupDialog({
    required this.availableExercises,
    this.initialGroup,
  });

  final List<ExerciseListItemViewModel> availableExercises;
  final WorkoutGroupListItemViewModel? initialGroup;

  @override
  State<_WorkoutGroupDialog> createState() => _WorkoutGroupDialogState();
}

class _WorkoutGroupDialogState extends State<_WorkoutGroupDialog> {
  late final TextEditingController _nameController;
  late final Set<String> _selectedKeys;
  String? _error;

  bool get _isEditing => widget.initialGroup != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialGroup?.name);
    _selectedKeys = {
      for (final exercise
          in widget.initialGroup?.exercises ??
              const <ExerciseListItemViewModel>[])
        _exerciseKey(exercise),
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        _isEditing
            ? localizations.customFolderEditTitle
            : localizations.customFolderCreateTitle,
      ),
      content: SizedBox(
        width: 560,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('custom_folder_name_field'),
              controller: _nameController,
              decoration: InputDecoration(
                labelText: localizations.customFolderNameLabel,
              ),
            ),
            const SizedBox(height: RepForgeSpacing.md),
            Text(
              localizations.customFolderAssignmentsTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: RepForgeSpacing.sm),
            Flexible(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: RepForgeColorTokens.borderSubtle),
                  borderRadius: BorderRadius.circular(RepForgeRadius.sm),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.availableExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = widget.availableExercises[index];
                    final key = _exerciseKey(exercise);
                    return CheckboxListTile(
                      key: Key('custom_folder_assignment_$key'),
                      value: _selectedKeys.contains(key),
                      onChanged: (selected) {
                        setState(() {
                          if (selected ?? false) {
                            _selectedKeys.add(key);
                          } else {
                            _selectedKeys.remove(key);
                          }
                        });
                      },
                      title: Text(exercise.name),
                      subtitle: Text(
                        exercise.isCustom
                            ? localizations.exercisesCustomBadge
                            : localizations.exercisesOfficialBadge,
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: RepForgeSpacing.md),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: RepForgeColorTokens.error,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.customFolderCancel),
        ),
        FilledButton.icon(
          key: const Key('custom_folder_save_button'),
          onPressed: _save,
          icon: const Icon(Icons.check),
          label: Text(localizations.customFolderSave),
        ),
      ],
    );
  }

  void _save() {
    final localizations = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _error = localizations.customFolderNameRequired;
      });
      return;
    }

    final selected = [
      for (final exercise in widget.availableExercises)
        if (_selectedKeys.contains(_exerciseKey(exercise))) exercise,
    ];
    Navigator.of(
      context,
    ).pop(WorkoutGroupDraft(name: name, exercises: selected));
  }
}

String _exerciseKey(ExerciseListItemViewModel exercise) {
  return '${exercise.source.name}_${exercise.id}';
}
