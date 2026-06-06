import '../application/analytics_application.dart';

enum ExerciseAnalyticsChartRange {
  day(days: 1),
  week(days: 7),
  twoWeeks(days: 14),
  month(days: 30),
  threeMonths(days: 90),
  sixMonths(days: 180),
  all(days: null);

  const ExerciseAnalyticsChartRange({required this.days});

  final int? days;

  ExerciseAnalyticsPeriod? periodEndingAt(DateTime now) {
    final rangeDays = days;
    if (rangeDays == null) {
      return null;
    }

    final end = now.toUtc();
    return ExerciseAnalyticsPeriod(
      start: end.subtract(Duration(days: rangeDays)),
      end: end,
    );
  }
}
