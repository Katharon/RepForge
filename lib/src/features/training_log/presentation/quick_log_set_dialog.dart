import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../exercise_catalog/domain/exercise_catalog_domain.dart';
import '../../exercise_catalog/presentation/exercise_catalog_loader.dart';
import '../application/training_log_application.dart';
import '../domain/training_log_domain.dart';

typedef WorkoutSetIdProvider = WorkoutSetId Function();
typedef QuickLogNowProvider = DateTime Function();

final class QuickLogSetController {
  const QuickLogSetController({
    required this.exerciseCatalogRepository,
    required this.saveWorkoutSet,
    this.customExerciseRepository,
    this.ensureCatalogImported,
    this.workoutSessionController,
    this.workoutSetIdProvider = _defaultWorkoutSetId,
    this.nowProvider = DateTime.now,
  });

  final ExerciseCatalogRepository exerciseCatalogRepository;
  final CustomExerciseRepository? customExerciseRepository;
  final SaveWorkoutSet saveWorkoutSet;
  final EnsureOfficialCatalogImported? ensureCatalogImported;
  final WorkoutSessionController? workoutSessionController;
  final WorkoutSetIdProvider workoutSetIdProvider;
  final QuickLogNowProvider nowProvider;

  Future<bool> show(
    BuildContext context, [
    ExerciseRef? initialExerciseRef,
  ]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return _QuickLogSetDialog(
          exerciseCatalogRepository: exerciseCatalogRepository,
          customExerciseRepository: customExerciseRepository,
          saveWorkoutSet: saveWorkoutSet,
          ensureCatalogImported: ensureCatalogImported,
          workoutSessionController: workoutSessionController,
          workoutSetIdProvider: workoutSetIdProvider,
          nowProvider: nowProvider,
          initialExerciseRef: initialExerciseRef,
        );
      },
    );

    return saved ?? false;
  }
}

WorkoutSetId _defaultWorkoutSetId() {
  return WorkoutSetId('quick_${DateTime.now().toUtc().microsecondsSinceEpoch}');
}

class _QuickLogSetDialog extends StatefulWidget {
  const _QuickLogSetDialog({
    required this.exerciseCatalogRepository,
    required this.customExerciseRepository,
    required this.saveWorkoutSet,
    required this.workoutSetIdProvider,
    required this.nowProvider,
    this.ensureCatalogImported,
    this.workoutSessionController,
    this.initialExerciseRef,
  });

  final ExerciseCatalogRepository exerciseCatalogRepository;
  final CustomExerciseRepository? customExerciseRepository;
  final SaveWorkoutSet saveWorkoutSet;
  final EnsureOfficialCatalogImported? ensureCatalogImported;
  final WorkoutSetIdProvider workoutSetIdProvider;
  final QuickLogNowProvider nowProvider;
  final WorkoutSessionController? workoutSessionController;
  final ExerciseRef? initialExerciseRef;

  @override
  State<_QuickLogSetDialog> createState() => _QuickLogSetDialogState();
}

class _QuickLogSetDialogState extends State<_QuickLogSetDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _loadController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  var _label = WorkoutSetLabel.none;
  var _isLoading = true;
  var _isSaving = false;
  Object? _error;
  List<ExerciseListItemViewModel> _exercises =
      const <ExerciseListItemViewModel>[];
  ExerciseListItemViewModel? _selectedExercise;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_loadExercises());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _loadController.dispose();
    _repetitionsController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.quickLogTitle),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('quick_log_exercise_search_field'),
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: localizations.quickLogExerciseSearchLabel,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _loadExercises(),
                    ),
                  ),
                  const SizedBox(width: RepForgeSpacing.md),
                  IconButton.filled(
                    key: const Key('quick_log_exercise_search_button'),
                    onPressed: _isLoading ? null : _loadExercises,
                    icon: const Icon(Icons.search),
                    tooltip: localizations.exercisesSearchTooltip,
                  ),
                ],
              ),
              const SizedBox(height: RepForgeSpacing.md),
              _exercisePicker(localizations),
              const SizedBox(height: RepForgeSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('quick_log_load_field'),
                      controller: _loadController,
                      decoration: InputDecoration(
                        labelText: localizations.quickLogLoadLabel,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: RepForgeSpacing.md),
                  Expanded(
                    child: TextField(
                      key: const Key('quick_log_repetitions_field'),
                      controller: _repetitionsController,
                      decoration: InputDecoration(
                        labelText: localizations.quickLogRepetitionsLabel,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RepForgeSpacing.md),
              DropdownButtonFormField<WorkoutSetLabel>(
                key: const Key('quick_log_label_field'),
                initialValue: _label,
                decoration: InputDecoration(
                  labelText: localizations.quickLogLabelLabel,
                ),
                items: [
                  for (final label in WorkoutSetLabel.values)
                    DropdownMenuItem<WorkoutSetLabel>(
                      value: label,
                      child: Text(_labelText(localizations, label)),
                    ),
                ],
                onChanged: (label) {
                  if (label == null) {
                    return;
                  }
                  setState(() {
                    _label = label;
                  });
                },
              ),
              const SizedBox(height: RepForgeSpacing.md),
              TextField(
                key: const Key('quick_log_comment_field'),
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: localizations.quickLogCommentLabel,
                ),
                maxLines: 2,
              ),
              if (_error != null) ...[
                const SizedBox(height: RepForgeSpacing.md),
                Text(
                  localizations.quickLogSaveError,
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
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: Text(localizations.quickLogCancel),
        ),
        FilledButton.icon(
          key: const Key('quick_log_save_button'),
          onPressed: _selectedExercise == null || _isSaving ? null : _save,
          icon: _isSaving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
          label: Text(localizations.quickLogSave),
        ),
      ],
    );
  }

  Widget _exercisePicker(AppLocalizations localizations) {
    if (_isLoading) {
      return Row(
        children: [
          const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: RepForgeSpacing.md),
          Expanded(child: Text(localizations.exercisesLoading)),
        ],
      );
    }

    if (_exercises.isEmpty) {
      return Text(localizations.quickLogNoExercises);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: RepForgeColorTokens.borderSubtle),
        borderRadius: BorderRadius.circular(RepForgeRadius.sm),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _exercises.length,
          itemBuilder: (context, index) {
            final exercise = _exercises[index];
            final selected = exercise == _selectedExercise;
            return ListTile(
              key: Key(
                'quick_log_exercise_${exercise.source.name}_${exercise.id}',
              ),
              onTap: () {
                setState(() {
                  _selectedExercise = exercise;
                });
              },
              title: Text(exercise.name),
              subtitle: Text(
                exercise.primaryMuscles.map(_formatTag).take(2).join(', '),
              ),
              trailing: Icon(
                selected ? Icons.radio_button_checked : Icons.circle_outlined,
                color: selected
                    ? RepForgeColorTokens.accentPrimaryGreen
                    : RepForgeColorTokens.textSecondary,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _loadExercises() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final locale = Localizations.localeOf(context);
      await widget.ensureCatalogImported?.call();
      final initialExercise = await _findInitialExercise(locale);
      final loader = RepositoryExerciseCatalogListLoader(
        repository: widget.exerciseCatalogRepository,
        customExerciseRepository: widget.customExerciseRepository,
        limit: 25,
      );
      final page = await loader.load(
        searchText: _searchController.text,
        locale: locale,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _exercises = _mergeInitialExercise(initialExercise, page.exercises);
        _selectedExercise = _exercises.contains(_selectedExercise)
            ? _selectedExercise
            : initialExercise ?? (_exercises.isEmpty ? null : _exercises.first);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  Future<ExerciseListItemViewModel?> _findInitialExercise(Locale locale) async {
    final initialExerciseRef = widget.initialExerciseRef;
    if (initialExerciseRef == null ||
        _selectedExercise != null ||
        _searchController.text.trim().isNotEmpty) {
      return null;
    }

    if (initialExerciseRef.source == ExerciseSource.custom) {
      final custom = await widget.customExerciseRepository
          ?.findCustomExerciseById(CustomExerciseId(initialExerciseRef.id));
      return custom == null
          ? ExerciseListItemViewModel(
              id: initialExerciseRef.id,
              name: initialExerciseRef.displayNameSnapshot,
              source: ExerciseSource.custom,
              equipment: const <String>[],
              movementPatterns: const <String>[],
              primaryMuscles: const <String>[],
            )
          : ExerciseListItemViewModel.fromCustomExercise(custom);
    }

    final official = await widget.exerciseCatalogRepository
        .findOfficialExerciseById(OfficialExerciseId(initialExerciseRef.id));
    return official == null
        ? null
        : ExerciseListItemViewModel.fromExercise(official, locale: locale);
  }

  List<ExerciseListItemViewModel> _mergeInitialExercise(
    ExerciseListItemViewModel? initialExercise,
    List<ExerciseListItemViewModel> exercises,
  ) {
    if (initialExercise == null) {
      return exercises;
    }

    return [
      initialExercise,
      for (final exercise in exercises)
        if (exercise.source != initialExercise.source ||
            exercise.id != initialExercise.id)
          exercise,
    ];
  }

  Future<void> _save() async {
    final exercise = _selectedExercise;
    if (exercise == null) {
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      final workoutSessionId =
          widget.workoutSessionController?.snapshot.active?.id;
      await widget.saveWorkoutSet(
        WorkoutSetForm(
          targetExerciseRef: exercise.toExerciseRef(),
          loadKgInput: _loadController.text,
          repetitionsInput: _repetitionsController.text,
          performedAt: widget.nowProvider(),
          labelInput: _label.storageValue,
          commentInput: _commentController.text,
        ),
        workoutSetId: widget.workoutSetIdProvider(),
        workoutSessionId: workoutSessionId,
      );
      if (workoutSessionId != null) {
        await widget.workoutSessionController?.refreshActiveSummary();
      }
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = error;
        _isSaving = false;
      });
    }
  }
}

String _labelText(AppLocalizations localizations, WorkoutSetLabel label) {
  return switch (label) {
    WorkoutSetLabel.none => localizations.quickLogLabelNone,
    WorkoutSetLabel.warmup => localizations.quickLogLabelWarmup,
    WorkoutSetLabel.failure => localizations.quickLogLabelFailure,
    WorkoutSetLabel.personalRecord => localizations.quickLogLabelPersonalRecord,
    WorkoutSetLabel.dropSet => localizations.quickLogLabelDropSet,
    WorkoutSetLabel.pain => localizations.quickLogLabelPain,
  };
}

String _formatTag(String tag) {
  return tag
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
