import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../application/settings_application.dart';
import '../domain/settings_domain.dart';

enum SettingsPageStatus { loading, error, ready, saving, saved }

final class SettingsPageState {
  const SettingsPageState({
    required this.status,
    this.profile,
    this.error,
    this.usesDefaults = false,
  });

  final SettingsPageStatus status;
  final SettingsProfile? profile;
  final Object? error;
  final bool usesDefaults;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.loadSettings,
    required this.saveSettings,
    required this.resetSettings,
    super.key,
  });

  final LoadSettingsProfile loadSettings;
  final SaveSettingsProfile saveSettings;
  final ResetSettingsProfile resetSettings;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _displayNameController = TextEditingController();
  var _requestVersion = 0;
  SettingsPageState _state = const SettingsPageState(
    status: SettingsPageStatus.loading,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant SettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loadSettings != widget.loadSettings) {
      unawaited(_load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: Text(localizations.navSettings)),
        AppResponsiveSliverList(
          children: [
            _SettingsStateBody(
              state: _state,
              displayNameController: _displayNameController,
              onChanged: _updateProfile,
              onEquipmentToggled: _toggleEquipment,
              onSave: _save,
              onReset: _reset,
              onRetry: _load,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _load() async {
    final requestVersion = ++_requestVersion;
    setState(() {
      _state = const SettingsPageState(status: SettingsPageStatus.loading);
    });

    try {
      final profile = await widget.loadSettings();
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }
      _syncDisplayName(profile);
      setState(() {
        _state = SettingsPageState(
          status: SettingsPageStatus.ready,
          profile: profile,
          usesDefaults: profile == SettingsProfile.defaults(),
        );
      });
    } catch (error) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }
      setState(() {
        _state = SettingsPageState(
          status: SettingsPageStatus.error,
          error: error,
        );
      });
    }
  }

  Future<void> _save() async {
    final profile = _state.profile;
    if (profile == null) {
      return;
    }

    final editedProfile = profile.copyWith(
      userProfile: UserProfile(displayName: _displayNameController.text),
    );
    setState(() {
      _state = SettingsPageState(
        status: SettingsPageStatus.saving,
        profile: editedProfile,
        usesDefaults: editedProfile == SettingsProfile.defaults(),
      );
    });

    try {
      await widget.saveSettings(editedProfile);
      if (!mounted) {
        return;
      }
      _syncDisplayName(editedProfile);
      setState(() {
        _state = SettingsPageState(
          status: SettingsPageStatus.saved,
          profile: editedProfile,
          usesDefaults: editedProfile == SettingsProfile.defaults(),
        );
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _state = SettingsPageState(
          status: SettingsPageStatus.error,
          profile: editedProfile,
          error: error,
        );
      });
    }
  }

  Future<void> _reset() async {
    setState(() {
      _state = SettingsPageState(
        status: SettingsPageStatus.saving,
        profile: _state.profile,
      );
    });

    try {
      final profile = await widget.resetSettings();
      if (!mounted) {
        return;
      }
      _syncDisplayName(profile);
      setState(() {
        _state = SettingsPageState(
          status: SettingsPageStatus.saved,
          profile: profile,
          usesDefaults: true,
        );
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _state = SettingsPageState(
          status: SettingsPageStatus.error,
          profile: _state.profile,
          error: error,
        );
      });
    }
  }

  void _updateProfile(SettingsProfile profile) {
    setState(() {
      _state = SettingsPageState(
        status: SettingsPageStatus.ready,
        profile: profile,
        usesDefaults: profile == SettingsProfile.defaults(),
      );
    });
  }

  void _toggleEquipment(AvailableEquipment equipment) {
    final profile = _state.profile;
    if (profile == null) {
      return;
    }

    final selected = Set<AvailableEquipment>.of(
      profile.equipmentInventory.items,
    );
    if (selected.contains(equipment)) {
      if (selected.length == 1) {
        return;
      }
      selected.remove(equipment);
    } else {
      selected.add(equipment);
    }
    final loadConstraints = Map<AvailableEquipment, EquipmentLoadConstraint>.of(
      profile.equipmentInventory.loadConstraints,
    )..removeWhere((equipment, _) => !selected.contains(equipment));
    _updateProfile(
      profile.copyWith(
        equipmentInventory: EquipmentInventory(
          selected,
          loadConstraints: loadConstraints,
        ),
      ),
    );
  }

  void _syncDisplayName(SettingsProfile profile) {
    _displayNameController.text = profile.userProfile.displayName ?? '';
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }
}

class _SettingsStateBody extends StatelessWidget {
  const _SettingsStateBody({
    required this.state,
    required this.displayNameController,
    required this.onChanged,
    required this.onEquipmentToggled,
    required this.onSave,
    required this.onReset,
    required this.onRetry,
  });

  final SettingsPageState state;
  final TextEditingController displayNameController;
  final ValueChanged<SettingsProfile> onChanged;
  final ValueChanged<AvailableEquipment> onEquipmentToggled;
  final VoidCallback onSave;
  final VoidCallback onReset;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case SettingsPageStatus.loading:
        return const _SettingsLoadingState();
      case SettingsPageStatus.error:
        return _SettingsErrorState(onRetry: onRetry);
      case SettingsPageStatus.ready:
      case SettingsPageStatus.saving:
      case SettingsPageStatus.saved:
        return _SettingsForm(
          state: state,
          displayNameController: displayNameController,
          onChanged: onChanged,
          onEquipmentToggled: onEquipmentToggled,
          onSave: onSave,
          onReset: onReset,
        );
    }
  }
}

class _SettingsLoadingState extends StatelessWidget {
  const _SettingsLoadingState();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Row(
        children: [
          const SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: RepForgeSpacing.md),
          Expanded(child: Text(localizations.settingsLoading)),
        ],
      ),
    );
  }
}

class _SettingsErrorState extends StatelessWidget {
  const _SettingsErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: RepForgeColorTokens.error),
          const SizedBox(height: RepForgeSpacing.md),
          Text(
            localizations.settingsErrorTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            localizations.settingsErrorMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
          const SizedBox(height: RepForgeSpacing.md),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(localizations.settingsRetry),
          ),
        ],
      ),
    );
  }
}

class _SettingsForm extends StatelessWidget {
  const _SettingsForm({
    required this.state,
    required this.displayNameController,
    required this.onChanged,
    required this.onEquipmentToggled,
    required this.onSave,
    required this.onReset,
  });

  final SettingsPageState state;
  final TextEditingController displayNameController;
  final ValueChanged<SettingsProfile> onChanged;
  final ValueChanged<AvailableEquipment> onEquipmentToggled;
  final VoidCallback onSave;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final profile = state.profile!;
    final isSaving = state.status == SettingsPageStatus.saving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.usesDefaults || state.status == SettingsPageStatus.saved) ...[
          AppCard(
            child: Text(
              state.status == SettingsPageStatus.saved
                  ? localizations.settingsSaved
                  : localizations.settingsUsingDefaults,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: RepForgeSpacing.md),
        ],
        _SettingsSection(
          title: localizations.settingsAppPreferencesTitle,
          children: [
            _DropdownRow<LanguageOverride>(
              fieldKey: const Key('settings_language_dropdown'),
              label: localizations.settingsLanguageLabel,
              value: profile.languageOverride,
              values: LanguageOverride.values,
              labelFor: (value) => _languageLabel(localizations, value),
              onChanged: (value) {
                onChanged(profile.copyWith(languageOverride: value));
              },
            ),
            _DropdownRow<UnitPreference>(
              fieldKey: const Key('settings_unit_dropdown'),
              label: localizations.settingsUnitsLabel,
              value: profile.unitPreference,
              values: UnitPreference.values,
              labelFor: (value) => _unitLabel(localizations, value),
              onChanged: (value) {
                onChanged(profile.copyWith(unitPreference: value));
              },
            ),
            _DropdownRow<ThemePreference>(
              fieldKey: const Key('settings_theme_dropdown'),
              label: localizations.settingsThemeLabel,
              value: profile.themePreference,
              values: ThemePreference.values,
              labelFor: (value) => _themeLabel(localizations, value),
              onChanged: (value) {
                onChanged(profile.copyWith(themePreference: value));
              },
            ),
          ],
        ),
        const SizedBox(height: RepForgeSpacing.md),
        _SettingsSection(
          title: localizations.settingsProfileTitle,
          children: [
            TextField(
              key: const Key('settings_display_name_field'),
              controller: displayNameController,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: localizations.settingsDisplayNameLabel,
                counterText: '',
              ),
            ),
          ],
        ),
        const SizedBox(height: RepForgeSpacing.md),
        _SettingsSection(
          title: localizations.settingsTrainingTitle,
          children: [
            _DropdownRow<int>(
              fieldKey: const Key('settings_rest_time_dropdown'),
              label: localizations.settingsDefaultRestLabel,
              value: profile.defaultRestTime.inSeconds,
              values: const <int>[60, 90, 120, 180],
              labelFor: (seconds) => localizations.settingsSeconds(seconds),
              onChanged: (value) {
                onChanged(
                  profile.copyWith(
                    defaultRestTime: DefaultRestTime.seconds(value),
                  ),
                );
              },
            ),
            _DropdownRow<FocusProfile>(
              fieldKey: const Key('settings_focus_dropdown'),
              label: localizations.settingsFocusLabel,
              value: profile.focusProfile,
              values: FocusProfile.values,
              labelFor: (value) => _focusLabel(localizations, value),
              onChanged: (value) {
                onChanged(profile.copyWith(focusProfile: value));
              },
            ),
            _DropdownRow<int>(
              fieldKey: const Key('settings_frequency_dropdown'),
              label: localizations.settingsTrainingFrequencyLabel,
              value: profile.trainingFrequency.daysPerWeek,
              values: const <int>[1, 2, 3, 4, 5, 6, 7],
              labelFor: (days) => localizations.settingsDaysPerWeek(days),
              onChanged: (value) {
                onChanged(
                  profile.copyWith(trainingFrequency: TrainingFrequency(value)),
                );
              },
            ),
            _DropdownRow<SessionDurationPreference>(
              fieldKey: const Key('settings_session_duration_dropdown'),
              label: localizations.settingsSessionDurationLabel,
              value: profile.sessionDuration,
              values: SessionDurationPreference.values,
              labelFor: (value) => localizations.settingsMinutes(value.minutes),
              onChanged: (value) {
                onChanged(profile.copyWith(sessionDuration: value));
              },
            ),
          ],
        ),
        const SizedBox(height: RepForgeSpacing.md),
        _SettingsSection(
          title: localizations.settingsEquipmentTitle,
          children: [
            Wrap(
              spacing: RepForgeSpacing.sm,
              runSpacing: RepForgeSpacing.sm,
              children: [
                for (final equipment in AvailableEquipment.values)
                  FilterChip(
                    key: Key('settings_equipment_${equipment.name}'),
                    label: Text(_equipmentLabel(localizations, equipment)),
                    selected: profile.equipmentInventory.contains(equipment),
                    onSelected: (_) => onEquipmentToggled(equipment),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: RepForgeSpacing.lg),
        Wrap(
          spacing: RepForgeSpacing.sm,
          runSpacing: RepForgeSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 180, minHeight: 48),
              child: Semantics(
                button: true,
                enabled: !isSaving,
                label: localizations.settingsSave,
                child: FilledButton.icon(
                  key: const Key('settings_save_button'),
                  onPressed: isSaving ? null : onSave,
                  icon: isSaving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    isSaving
                        ? localizations.settingsSaving
                        : localizations.settingsSave,
                  ),
                ),
              ),
            ),
            Semantics(
              button: true,
              enabled: !isSaving,
              label: localizations.settingsReset,
              child: IconButton(
                key: const Key('settings_reset_button'),
                tooltip: localizations.settingsReset,
                onPressed: isSaving ? null : onReset,
                icon: Icon(
                  Icons.restart_alt,
                  semanticLabel: localizations.settingsReset,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

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
      padding: const EdgeInsets.only(bottom: RepForgeSpacing.sm),
      child: DropdownButtonFormField<T>(
        key: fieldKey,
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final item in values)
            DropdownMenuItem<T>(
              value: item,
              child: Text(labelFor(item), overflow: TextOverflow.ellipsis),
            ),
        ],
        isExpanded: true,
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

String _languageLabel(AppLocalizations localizations, LanguageOverride value) {
  return switch (value) {
    LanguageOverride.system => localizations.settingsLanguageSystem,
    LanguageOverride.english => localizations.settingsLanguageEnglish,
    LanguageOverride.german => localizations.settingsLanguageGerman,
  };
}

String _unitLabel(AppLocalizations localizations, UnitPreference value) {
  return switch (value) {
    UnitPreference.metric => localizations.settingsUnitsMetric,
    UnitPreference.imperial => localizations.settingsUnitsImperial,
  };
}

String _themeLabel(AppLocalizations localizations, ThemePreference value) {
  return switch (value) {
    ThemePreference.system => localizations.settingsThemeSystem,
    ThemePreference.dark => localizations.settingsThemeDark,
    ThemePreference.light => localizations.settingsThemeLight,
  };
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
    AvailableEquipment.rack => localizations.settingsEquipmentRack,
    AvailableEquipment.legPress => localizations.settingsEquipmentLegPress,
  };
}
