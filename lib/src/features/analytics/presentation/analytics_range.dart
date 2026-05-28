import '../application/analytics_application.dart';

enum ExerciseAnalyticsRange {
  sevenDays(days: 7),
  thirtyDays(days: 30),
  ninetyDays(days: 90);

  const ExerciseAnalyticsRange({required this.days});

  final int days;

  ExerciseAnalyticsPeriod periodEndingAt(DateTime now) {
    final end = now.toUtc();

    return ExerciseAnalyticsPeriod(
      start: end.subtract(Duration(days: days)),
      end: end,
    );
  }
}
