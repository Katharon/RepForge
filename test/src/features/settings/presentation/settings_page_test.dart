import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/settings/application/settings_application.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/settings/presentation/settings_presentation.dart';

void main() {
  testWidgets('loading state renders', (tester) async {
    await tester.pumpWidget(_testApp(_page(_PendingSettingsRepository())));

    expect(find.text('Loading settings'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('default state renders local defaults and controls', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(_page(_SettingsRepositoryFake())));
    await tester.pumpAndSettle();

    expect(find.text('Using local defaults'), findsOneWidget);
    expect(find.text('App preferences'), findsOneWidget);
    expect(find.text('Profile basics'), findsOneWidget);
    expect(find.text('Training preferences'), findsOneWidget);
    expect(find.text('Available equipment'), findsOneWidget);
    expect(find.text('Bodyweight'), findsOneWidget);
  });

  testWidgets('settings controls expose semantics and touch targets', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(_page(_SettingsRepositoryFake())));
    await tester.pumpAndSettle();

    expect(_semanticsLabel('Save settings'), findsOneWidget);
    expect(_semanticsLabel('Reset to defaults'), findsWidgets);

    final resetSize = tester.getSize(
      find.byKey(const Key('settings_reset_button')),
    );
    expect(resetSize.width, greaterThanOrEqualTo(48));
    expect(resetSize.height, greaterThanOrEqualTo(48));
  });

  testWidgets('settings form remains readable at increased text scale', (
    tester,
  ) async {
    _useTallTestSurface(tester);

    await tester.pumpWidget(
      _testApp(
        _page(_SettingsRepositoryFake()),
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('App preferences'), findsOneWidget);
    expect(find.text('Save settings'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('error state renders retry copy', (tester) async {
    await tester.pumpWidget(_testApp(_page(_FailingSettingsRepository())));
    await tester.pumpAndSettle();

    expect(find.text('Settings could not load'), findsOneWidget);
    expect(find.text('Try again without changing local data.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('successful load renders saved choices', (tester) async {
    final repository = _SettingsRepositoryFake(
      SettingsProfile.defaults().copyWith(
        languageOverride: LanguageOverride.german,
        unitPreference: UnitPreference.imperial,
        themePreference: ThemePreference.dark,
        defaultRestTime: DefaultRestTime.seconds(120),
        userProfile: UserProfile(displayName: 'Luki'),
        focusProfile: FocusProfile.strengthBasics,
        trainingFrequency: TrainingFrequency(5),
        sessionDuration: SessionDurationPreference.sixty,
        equipmentInventory: EquipmentInventory(const <AvailableEquipment>[
          AvailableEquipment.dumbbell,
          AvailableEquipment.bench,
        ]),
      ),
    );

    await tester.pumpWidget(_testApp(_page(repository)));
    await tester.pumpAndSettle();

    expect(find.text('German'), findsOneWidget);
    expect(find.text('Imperial'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('120 sec'), findsOneWidget);
    expect(find.text('Strength basics'), findsOneWidget);
    expect(find.text('5 days/week'), findsOneWidget);
    expect(find.text('60 min'), findsOneWidget);
    expect(find.text('Luki'), findsOneWidget);
  });

  testWidgets('editing and saving settings persists through use case', (
    tester,
  ) async {
    _useTallTestSurface(tester);
    final repository = _SettingsRepositoryFake();

    await tester.pumpWidget(_testApp(_page(repository)));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('settings_display_name_field')),
      'Mira',
    );
    await _selectDropdownValue(
      tester,
      const Key('settings_language_dropdown'),
      'German',
    );
    await _selectDropdownValue(
      tester,
      const Key('settings_unit_dropdown'),
      'Imperial',
    );
    await _selectDropdownValue(
      tester,
      const Key('settings_theme_dropdown'),
      'Light',
    );
    await _selectDropdownValue(
      tester,
      const Key('settings_rest_time_dropdown'),
      '120 sec',
    );
    await tester.tap(
      _filterChip(const Key('settings_equipment_dumbbell')).first,
    );
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.tap(
      _byKeyWidget<FilledButton>(const Key('settings_save_button')).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Saved locally'), findsOneWidget);
    expect(repository.profile.languageOverride, LanguageOverride.german);
    expect(repository.profile.unitPreference, UnitPreference.imperial);
    expect(repository.profile.themePreference, ThemePreference.light);
    expect(repository.profile.defaultRestTime.inSeconds, 120);
    expect(repository.profile.userProfile.displayName, 'Mira');
    expect(
      repository.profile.equipmentInventory.contains(
        AvailableEquipment.dumbbell,
      ),
      isTrue,
    );
  });

  testWidgets('equipment checklist toggles structured selections', (
    tester,
  ) async {
    _useTallTestSurface(tester);
    final repository = _SettingsRepositoryFake();

    await tester.pumpWidget(_testApp(_page(repository)));
    await tester.pumpAndSettle();

    final dumbbellChip = tester.widget<FilterChip>(
      find.byKey(const Key('settings_equipment_dumbbell')),
    );
    expect(dumbbellChip.selected, isFalse);

    await tester.tap(
      _filterChip(const Key('settings_equipment_dumbbell')).first,
    );
    await tester.pumpAndSettle();

    final selectedDumbbellChip = tester.widget<FilterChip>(
      find.byKey(const Key('settings_equipment_dumbbell')),
    );
    expect(selectedDumbbellChip.selected, isTrue);
  });
}

Widget _page(SettingsProfileRepository repository) {
  return SettingsPage(
    loadSettings: LoadSettingsProfile(repository),
    saveSettings: SaveSettingsProfile(repository),
    resetSettings: ResetSettingsProfile(repository),
  );
}

Widget _testApp(Widget child, {TextScaler textScaler = TextScaler.noScaling}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: MediaQuery(
      data: MediaQueryData(textScaler: textScaler),
      child: Scaffold(body: child),
    ),
  );
}

Future<void> _selectDropdownValue(
  WidgetTester tester,
  Key dropdownKey,
  String label,
) async {
  final finder = _dropdown(dropdownKey);
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Finder _filterChip(Key key) {
  return _byKeyWidget<FilterChip>(key);
}

Finder _dropdown(Key key) {
  return find.byWidgetPredicate((widget) {
    return widget is DropdownButtonFormField && widget.key == key;
  });
}

Finder _byKeyWidget<T extends Widget>(Key key) {
  return find.byWidgetPredicate((widget) {
    return widget is T && widget.key == key;
  });
}

Finder _semanticsLabel(String label) {
  return find.byWidgetPredicate((widget) {
    return widget is Semantics && widget.properties.label == label;
  });
}

void _useTallTestSurface(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 1600);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

final class _SettingsRepositoryFake implements SettingsProfileRepository {
  _SettingsRepositoryFake([SettingsProfile? profile])
    : profile = profile ?? SettingsProfile.defaults();

  SettingsProfile profile;

  @override
  Future<SettingsProfile> load() async => profile;

  @override
  Future<void> save(SettingsProfile profile) async {
    this.profile = profile;
  }
}

final class _PendingSettingsRepository implements SettingsProfileRepository {
  @override
  Future<SettingsProfile> load() {
    return Completer<SettingsProfile>().future;
  }

  @override
  Future<void> save(SettingsProfile profile) async {}
}

final class _FailingSettingsRepository implements SettingsProfileRepository {
  @override
  Future<SettingsProfile> load() {
    return Future<SettingsProfile>.error(StateError('boom'));
  }

  @override
  Future<void> save(SettingsProfile profile) async {}
}
