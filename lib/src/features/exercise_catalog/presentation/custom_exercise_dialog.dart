import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../domain/exercise_catalog_domain.dart';

final class CustomExerciseDraft {
  const CustomExerciseDraft({
    required this.name,
    required this.primaryMuscles,
    this.notes,
    this.secondaryMuscles = const <String>[],
    this.equipment = const <String>[],
    this.movementPatterns = const <String>[],
  });

  final String name;
  final String? notes;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> equipment;
  final List<String> movementPatterns;
}

Future<CustomExerciseDraft?> showCustomExerciseDialog({
  required BuildContext context,
  CustomExercise? initialExercise,
}) {
  return showDialog<CustomExerciseDraft>(
    context: context,
    builder: (context) {
      return _CustomExerciseDialog(initialExercise: initialExercise);
    },
  );
}

class _CustomExerciseDialog extends StatefulWidget {
  const _CustomExerciseDialog({this.initialExercise});

  final CustomExercise? initialExercise;

  @override
  State<_CustomExerciseDialog> createState() => _CustomExerciseDialogState();
}

class _CustomExerciseDialogState extends State<_CustomExerciseDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late final TextEditingController _primaryMusclesController;
  late final TextEditingController _secondaryMusclesController;
  late final TextEditingController _equipmentController;
  late final TextEditingController _movementPatternsController;
  String? _error;

  bool get _isEditing => widget.initialExercise != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialExercise;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _notesController = TextEditingController(text: initial?.notes ?? '');
    _primaryMusclesController = TextEditingController(
      text: _joinValues(initial?.primaryMuscles.map((muscle) => muscle.value)),
    );
    _secondaryMusclesController = TextEditingController(
      text: _joinValues(
        initial?.secondaryMuscles.map((muscle) => muscle.value),
      ),
    );
    _equipmentController = TextEditingController(
      text: _joinValues(initial?.equipment.map((tag) => tag.value)),
    );
    _movementPatternsController = TextEditingController(
      text: _joinValues(
        initial?.movementPatterns.map((pattern) => pattern.value),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _primaryMusclesController.dispose();
    _secondaryMusclesController.dispose();
    _equipmentController.dispose();
    _movementPatternsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        _isEditing
            ? localizations.customExerciseEditTitle
            : localizations.customExerciseCreateTitle,
      ),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('custom_exercise_name_field'),
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: localizations.customExerciseNameLabel,
                ),
              ),
              const SizedBox(height: RepForgeSpacing.md),
              TextField(
                key: const Key('custom_exercise_notes_field'),
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: localizations.customExerciseNotesLabel,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: RepForgeSpacing.md),
              TextField(
                key: const Key('custom_exercise_primary_muscles_field'),
                controller: _primaryMusclesController,
                decoration: InputDecoration(
                  labelText: localizations.customExercisePrimaryMusclesLabel,
                  helperText: localizations.customExerciseCommaHelper,
                ),
              ),
              const SizedBox(height: RepForgeSpacing.md),
              TextField(
                key: const Key('custom_exercise_secondary_muscles_field'),
                controller: _secondaryMusclesController,
                decoration: InputDecoration(
                  labelText: localizations.customExerciseSecondaryMusclesLabel,
                  helperText: localizations.customExerciseCommaHelper,
                ),
              ),
              const SizedBox(height: RepForgeSpacing.md),
              TextField(
                key: const Key('custom_exercise_equipment_field'),
                controller: _equipmentController,
                decoration: InputDecoration(
                  labelText: localizations.customExerciseEquipmentLabel,
                  helperText: localizations.customExerciseCommaHelper,
                ),
              ),
              const SizedBox(height: RepForgeSpacing.md),
              TextField(
                key: const Key('custom_exercise_movement_patterns_field'),
                controller: _movementPatternsController,
                decoration: InputDecoration(
                  labelText: localizations.customExerciseMovementPatternsLabel,
                  helperText: localizations.customExerciseCommaHelper,
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.customExerciseCancel),
        ),
        FilledButton.icon(
          key: const Key('custom_exercise_save_button'),
          onPressed: _save,
          icon: const Icon(Icons.check),
          label: Text(localizations.customExerciseSave),
        ),
      ],
    );
  }

  void _save() {
    final localizations = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    final primaryMuscles = _splitValues(_primaryMusclesController.text);
    if (name.isEmpty) {
      setState(() {
        _error = localizations.customExerciseNameRequired;
      });
      return;
    }
    if (primaryMuscles.isEmpty) {
      setState(() {
        _error = localizations.customExercisePrimaryMusclesRequired;
      });
      return;
    }

    Navigator.of(context).pop(
      CustomExerciseDraft(
        name: name,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        primaryMuscles: primaryMuscles,
        secondaryMuscles: _splitValues(_secondaryMusclesController.text),
        equipment: _splitValues(_equipmentController.text),
        movementPatterns: _splitValues(_movementPatternsController.text),
      ),
    );
  }
}

String _joinValues(Iterable<String>? values) {
  if (values == null) {
    return '';
  }
  return values.join(', ');
}

List<String> _splitValues(String value) {
  return value
      .split(',')
      .map((entry) => entry.trim())
      .where((entry) => entry.isNotEmpty)
      .toList(growable: false);
}
