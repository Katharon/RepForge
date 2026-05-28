import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../settings/domain/settings_domain.dart';
import '../application/onboarding_application.dart';
import '../domain/onboarding_domain.dart';

enum OnboardingPageStatus { editing, saving, saved, error }

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    required this.skipOnboarding,
    required this.completeOnboarding,
    required this.onFinished,
    super.key,
  });

  final SkipOnboarding skipOnboarding;
  final CompleteOnboarding completeOnboarding;
  final VoidCallback onFinished;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _displayNameController = TextEditingController();
  OnboardingStep _step = OnboardingStep.welcome;
  OnboardingDraft _draft = OnboardingDraft.defaults();
  OnboardingPageStatus _status = OnboardingPageStatus.editing;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: Text(localizations.onboardingTitle)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            RepForgeSpacing.lg,
            0,
            RepForgeSpacing.lg,
            RepForgeSpacing.xl,
          ),
          sliver: SliverList.list(
            children: [
              if (_status == OnboardingPageStatus.error) ...[
                _StatusCard(
                  icon: Icons.error_outline,
                  title: localizations.onboardingErrorTitle,
                  message: localizations.onboardingErrorMessage,
                ),
                const SizedBox(height: RepForgeSpacing.md),
              ],
              if (_status == OnboardingPageStatus.saved)
                _SavedStep(onFinished: widget.onFinished)
              else
                _stepBody(localizations),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepBody(AppLocalizations localizations) {
    return switch (_step) {
      OnboardingStep.welcome => _WelcomeStep(
        onStart: () => _goTo(OnboardingStep.profile),
        onSkip: _skip,
      ),
      OnboardingStep.profile => _ProfileStep(
        controller: _displayNameController,
        draft: _draft,
        onDraftChanged: _setDraft,
        onBack: () => _goTo(OnboardingStep.welcome),
        onNext: () {
          _setDraft(_draft.copyWith(displayName: _displayNameController.text));
          _goTo(OnboardingStep.training);
        },
      ),
      OnboardingStep.training => _TrainingStep(
        draft: _draft,
        onDraftChanged: _setDraft,
        onBack: () => _goTo(OnboardingStep.profile),
        onNext: () => _goTo(OnboardingStep.equipment),
      ),
      OnboardingStep.equipment => _EquipmentStep(
        draft: _draft,
        status: _status,
        onDraftChanged: _setDraft,
        onEquipmentToggled: _toggleEquipment,
        onBack: () => _goTo(OnboardingStep.training),
        onComplete: _complete,
      ),
      OnboardingStep.complete => _SavedStep(onFinished: widget.onFinished),
    };
  }

  void _setDraft(OnboardingDraft draft) {
    setState(() {
      _draft = draft;
      _status = OnboardingPageStatus.editing;
    });
  }

  void _toggleEquipment(AvailableEquipment equipment) {
    final selected = Set<AvailableEquipment>.of(
      _draft.equipmentInventory.items,
    );
    if (selected.contains(equipment)) {
      if (selected.length == 1) {
        return;
      }
      selected.remove(equipment);
    } else {
      selected.add(equipment);
    }
    _setDraft(
      _draft.copyWith(equipmentInventory: EquipmentInventory(selected)),
    );
  }

  void _goTo(OnboardingStep step) {
    setState(() {
      _step = step;
      _status = OnboardingPageStatus.editing;
    });
  }

  Future<void> _skip() async {
    setState(() {
      _status = OnboardingPageStatus.saving;
    });
    try {
      await widget.skipOnboarding();
      widget.onFinished();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = OnboardingPageStatus.error;
      });
    }
  }

  Future<void> _complete() async {
    setState(() {
      _status = OnboardingPageStatus.saving;
    });
    try {
      await widget.completeOnboarding(
        _draft.copyWith(displayName: _displayNameController.text),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _step = OnboardingStep.complete;
        _status = OnboardingPageStatus.saved;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = OnboardingPageStatus.error;
      });
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onStart, required this.onSkip});

  final VoidCallback onStart;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.fitness_center),
          const SizedBox(height: RepForgeSpacing.md),
          Text(
            localizations.onboardingWelcomeTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(localizations.onboardingWelcomeMessage),
          const SizedBox(height: RepForgeSpacing.lg),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  key: const Key('onboarding_start_button'),
                  onPressed: onStart,
                  child: Text(localizations.onboardingStart),
                ),
              ),
              const SizedBox(width: RepForgeSpacing.sm),
              TextButton(
                key: const Key('onboarding_skip_button'),
                onPressed: onSkip,
                child: Text(localizations.onboardingSkip),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileStep extends StatelessWidget {
  const _ProfileStep({
    required this.controller,
    required this.draft,
    required this.onDraftChanged,
    required this.onBack,
    required this.onNext,
  });

  final TextEditingController controller;
  final OnboardingDraft draft;
  final ValueChanged<OnboardingDraft> onDraftChanged;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _StepCard(
      title: localizations.onboardingProfileTitle,
      children: [
        TextField(
          key: const Key('onboarding_display_name_field'),
          controller: controller,
          maxLength: 80,
          decoration: InputDecoration(
            labelText: localizations.settingsDisplayNameLabel,
            counterText: '',
          ),
        ),
        const SizedBox(height: RepForgeSpacing.sm),
        _DropdownRow<FocusProfile>(
          fieldKey: const Key('onboarding_focus_dropdown'),
          label: localizations.settingsFocusLabel,
          value: draft.focusProfile,
          values: FocusProfile.values,
          labelFor: (value) => _focusLabel(localizations, value),
          onChanged: (value) {
            onDraftChanged(draft.copyWith(focusProfile: value));
          },
        ),
        _StepActions(onBack: onBack, onNext: onNext),
      ],
    );
  }
}

class _TrainingStep extends StatelessWidget {
  const _TrainingStep({
    required this.draft,
    required this.onDraftChanged,
    required this.onBack,
    required this.onNext,
  });

  final OnboardingDraft draft;
  final ValueChanged<OnboardingDraft> onDraftChanged;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _StepCard(
      title: localizations.onboardingTrainingTitle,
      children: [
        _DropdownRow<int>(
          fieldKey: const Key('onboarding_frequency_dropdown'),
          label: localizations.settingsTrainingFrequencyLabel,
          value: draft.trainingFrequency.daysPerWeek,
          values: const <int>[1, 2, 3, 4, 5, 6, 7],
          labelFor: (days) => localizations.settingsDaysPerWeek(days),
          onChanged: (value) {
            onDraftChanged(
              draft.copyWith(trainingFrequency: TrainingFrequency(value)),
            );
          },
        ),
        _DropdownRow<SessionDurationPreference>(
          fieldKey: const Key('onboarding_session_duration_dropdown'),
          label: localizations.settingsSessionDurationLabel,
          value: draft.sessionDuration,
          values: SessionDurationPreference.values,
          labelFor: (value) => localizations.settingsMinutes(value.minutes),
          onChanged: (value) {
            onDraftChanged(draft.copyWith(sessionDuration: value));
          },
        ),
        _StepActions(onBack: onBack, onNext: onNext),
      ],
    );
  }
}

class _EquipmentStep extends StatelessWidget {
  const _EquipmentStep({
    required this.draft,
    required this.status,
    required this.onDraftChanged,
    required this.onEquipmentToggled,
    required this.onBack,
    required this.onComplete,
  });

  final OnboardingDraft draft;
  final OnboardingPageStatus status;
  final ValueChanged<OnboardingDraft> onDraftChanged;
  final ValueChanged<AvailableEquipment> onEquipmentToggled;
  final VoidCallback onBack;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isSaving = status == OnboardingPageStatus.saving;
    return _StepCard(
      title: localizations.onboardingEquipmentTitle,
      children: [
        Wrap(
          spacing: RepForgeSpacing.sm,
          runSpacing: RepForgeSpacing.sm,
          children: [
            for (final equipment in AvailableEquipment.values)
              FilterChip(
                key: Key('onboarding_equipment_${equipment.name}'),
                label: Text(_equipmentLabel(localizations, equipment)),
                selected: draft.equipmentInventory.contains(equipment),
                onSelected: (_) => onEquipmentToggled(equipment),
              ),
          ],
        ),
        const SizedBox(height: RepForgeSpacing.md),
        InkWell(
          key: const Key('onboarding_starter_groups_checkbox'),
          onTap: () {
            onDraftChanged(
              draft.copyWith(createStarterGroups: !draft.createStarterGroups),
            );
          },
          child: Row(
            children: [
              Checkbox(
                value: draft.createStarterGroups,
                onChanged: (value) {
                  onDraftChanged(
                    draft.copyWith(createStarterGroups: value ?? false),
                  );
                },
              ),
              Expanded(child: Text(localizations.onboardingStarterGroupsTitle)),
            ],
          ),
        ),
        const SizedBox(height: RepForgeSpacing.md),
        Row(
          children: [
            TextButton(
              key: const Key('onboarding_back_button'),
              onPressed: isSaving ? null : onBack,
              child: Text(localizations.onboardingBack),
            ),
            const Spacer(),
            FilledButton.icon(
              key: const Key('onboarding_complete_button'),
              onPressed: isSaving ? null : onComplete,
              icon: isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(
                isSaving
                    ? localizations.settingsSaving
                    : localizations.onboardingComplete,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SavedStep extends StatelessWidget {
  const _SavedStep({required this.onFinished});

  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline),
          const SizedBox(height: RepForgeSpacing.md),
          Text(
            localizations.onboardingSavedTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(localizations.onboardingSavedMessage),
          const SizedBox(height: RepForgeSpacing.lg),
          FilledButton(
            key: const Key('onboarding_continue_button'),
            onPressed: onFinished,
            child: Text(localizations.onboardingContinue),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Icon(icon, color: RepForgeColorTokens.error),
          const SizedBox(width: RepForgeSpacing.md),
          Expanded(child: Text('$title. $message')),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: RepForgeSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _StepActions extends StatelessWidget {
  const _StepActions({required this.onBack, required this.onNext});

  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Row(
      children: [
        TextButton(
          key: const Key('onboarding_back_button'),
          onPressed: onBack,
          child: Text(localizations.onboardingBack),
        ),
        const Spacer(),
        FilledButton(
          key: const Key('onboarding_next_button'),
          onPressed: onNext,
          child: Text(localizations.onboardingNext),
        ),
      ],
    );
  }
}

class _DropdownRow<T extends Object> extends StatelessWidget {
  const _DropdownRow({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.values,
    required this.labelFor,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final T value;
  final List<T> values;
  final String Function(T value) labelFor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RepForgeSpacing.md),
      child: DropdownButtonFormField<T>(
        key: fieldKey,
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final item in values)
            DropdownMenuItem<T>(value: item, child: Text(labelFor(item))),
        ],
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

String _focusLabel(AppLocalizations localizations, FocusProfile value) {
  return switch (value) {
    FocusProfile.balanced => localizations.settingsFocusBalanced,
    FocusProfile.upperBodyFocus => localizations.settingsFocusUpperBody,
    FocusProfile.lowerBodyGluteFocus => localizations.settingsFocusLowerBody,
    FocusProfile.armsChestFocus => localizations.settingsFocusArmsChest,
    FocusProfile.strengthBasics => localizations.settingsFocusStrengthBasics,
    FocusProfile.timeEfficient => localizations.settingsFocusTimeEfficient,
    FocusProfile.beginnerFoundation =>
      localizations.settingsFocusBeginnerFoundation,
    FocusProfile.custom => localizations.settingsFocusCustom,
  };
}

String _equipmentLabel(
  AppLocalizations localizations,
  AvailableEquipment value,
) {
  return switch (value) {
    AvailableEquipment.bodyweight => localizations.settingsEquipmentBodyweight,
    AvailableEquipment.barbell => localizations.settingsEquipmentBarbell,
    AvailableEquipment.dumbbell => localizations.settingsEquipmentDumbbell,
    AvailableEquipment.cable => localizations.settingsEquipmentCable,
    AvailableEquipment.machine => localizations.settingsEquipmentMachine,
    AvailableEquipment.smithMachine =>
      localizations.settingsEquipmentSmithMachine,
    AvailableEquipment.pullUpBar => localizations.settingsEquipmentPullUpBar,
    AvailableEquipment.bench => localizations.settingsEquipmentBench,
    AvailableEquipment.legPress => localizations.settingsEquipmentLegPress,
  };
}
