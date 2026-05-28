import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';
import 'package:repforge/src/features/rest_timer/presentation/rest_timer_presentation.dart';
import 'package:repforge/src/features/today/presentation/today_presentation.dart';

void main() {
  testWidgets('loading state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _PendingTodayDashboardLoader())),
    );

    expect(find.text('Loading today'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_emptyModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('No sets logged today'), findsOneWidget);
    expect(
      find.text('Your daily summary will fill in as soon as sets are logged.'),
      findsOneWidget,
    );
    expect(find.text('Sets today'), findsOneWidget);
    expect(find.text('Volume today'), findsOneWidget);
  });

  testWidgets('error state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _FailingTodayDashboardLoader())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today could not load'), findsOneWidget);
    expect(find.text('Try again without changing local data.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('success state renders dashboard cards', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sets today'), findsOneWidget);
    expect(find.text('Volume today'), findsOneWidget);
    expect(find.text('Last logged'), findsOneWidget);
    expect(find.text('Rest timer'), findsOneWidget);
    expect(find.text('Quick action'), findsOneWidget);
    expect(find.text('Training signal'), findsOneWidget);
  });

  testWidgets('today set count and volume are displayed', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);
    expect(find.text('1250 kg'), findsOneWidget);
  });

  testWidgets('last logged set summary is displayed when available', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Barbell Bench Press: 5 reps at 100 kg'), findsOneWidget);
  });

  testWidgets('rest timer status and countdown are displayed when available', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Resting'), findsOneWidget);
    expect(find.text('01:30'), findsOneWidget);
  });

  testWidgets('quick action placeholder is present', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Log set'), findsOneWidget);
    expect(
      find.text('Quick logging will connect here in a later tracking slice.'),
      findsOneWidget,
    );
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

final class _PendingTodayDashboardLoader implements TodayDashboardLoader {
  @override
  Future<TodayDashboardReadModel> load() {
    return Completer<TodayDashboardReadModel>().future;
  }
}

final class _StaticTodayDashboardLoader implements TodayDashboardLoader {
  const _StaticTodayDashboardLoader(this.model);

  final TodayDashboardReadModel model;

  @override
  Future<TodayDashboardReadModel> load() {
    return Future.value(model);
  }
}

final class _FailingTodayDashboardLoader implements TodayDashboardLoader {
  @override
  Future<TodayDashboardReadModel> load() {
    return Future<TodayDashboardReadModel>.error(StateError('boom'));
  }
}

TodayDashboardReadModel _emptyModel() {
  return const TodayDashboardReadModel(
    setCount: 0,
    totalVolumeKg: 0,
    restTimer: RestTimerCountdownState(
      status: RestTimerStatus.idle,
      remaining: Duration.zero,
      displayText: '00:00',
      isVisible: false,
    ),
  );
}

TodayDashboardReadModel _successModel() {
  return const TodayDashboardReadModel(
    setCount: 4,
    totalVolumeKg: 1250,
    lastLoggedSet: TodayLastLoggedSetViewModel(
      exerciseName: 'Barbell Bench Press',
      repetitions: 5,
      loadKg: 100,
    ),
    restTimer: RestTimerCountdownState(
      status: RestTimerStatus.running,
      remaining: Duration(seconds: 90),
      displayText: '01:30',
      isVisible: true,
    ),
  );
}
