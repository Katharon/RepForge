import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/workout_groups/presentation/workout_groups_presentation.dart';

void main() {
  testWidgets('loading state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _PendingWorkoutGroupListLoader())),
    );

    expect(find.text('Loading groups'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(
        GroupsPage(
          loader: _StaticWorkoutGroupListLoader(
            const WorkoutGroupListViewModel(
              groups: [],
              totalCount: 0,
              hasMore: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No groups yet'), findsOneWidget);
    expect(find.text('Workout groups will be connected'), findsNothing);
  });

  testWidgets('error state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _FailingWorkoutGroupListLoader())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Groups could not load'), findsOneWidget);
    expect(find.text('Try again without changing local data.'), findsOneWidget);
  });

  testWidgets('success state renders group summary and coach preview', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        GroupsPage(
          loader: _StaticWorkoutGroupListLoader(
            const WorkoutGroupListViewModel(
              groups: [
                WorkoutGroupListItemViewModel(
                  id: 'push_day',
                  name: 'Push Day',
                  exerciseCount: 2,
                  exerciseNames: ['Barbell Bench Press', 'Overhead Press'],
                ),
              ],
              totalCount: 1,
              hasMore: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Push Day'), findsOneWidget);
    expect(find.text('2 exercises assigned'), findsOneWidget);
    expect(find.text('Barbell Bench Press, Overhead Press'), findsOneWidget);
    expect(find.text('Coach preview'), findsOneWidget);
  });

  testWidgets('group cards expose semantic summaries', (tester) async {
    await tester.pumpWidget(
      _testApp(
        GroupsPage(
          loader: _StaticWorkoutGroupListLoader(
            const WorkoutGroupListViewModel(
              groups: [
                WorkoutGroupListItemViewModel(
                  id: 'pull_day',
                  name: 'Pull Day',
                  exerciseCount: 1,
                  exerciseNames: ['Pull-up'],
                ),
              ],
              totalCount: 1,
              hasMore: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(_semanticsLabel('Pull Day, 1 exercise'), findsOneWidget);
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: Scaffold(body: child),
  );
}

Finder _semanticsLabel(String label) {
  return find.byWidgetPredicate((widget) {
    return widget is Semantics && widget.properties.label == label;
  });
}

final class _PendingWorkoutGroupListLoader implements WorkoutGroupListLoader {
  @override
  Future<WorkoutGroupListViewModel> load() {
    return Completer<WorkoutGroupListViewModel>().future;
  }
}

final class _StaticWorkoutGroupListLoader implements WorkoutGroupListLoader {
  const _StaticWorkoutGroupListLoader(this.model);

  final WorkoutGroupListViewModel model;

  @override
  Future<WorkoutGroupListViewModel> load() async {
    return model;
  }
}

final class _FailingWorkoutGroupListLoader implements WorkoutGroupListLoader {
  @override
  Future<WorkoutGroupListViewModel> load() {
    return Future<WorkoutGroupListViewModel>.error(StateError('boom'));
  }
}
