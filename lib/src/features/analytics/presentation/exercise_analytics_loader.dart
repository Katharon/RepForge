import 'package:repforge/src/features/analytics/application/analytics_application.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import 'analytics_range.dart';

typedef AnalyticsNowProvider = DateTime Function();

abstract interface class ExerciseAnalyticsLoader {
  Future<ExerciseAnalyticsReadModel> load(ExerciseAnalyticsLoadRequest request);
}

final class ExerciseAnalyticsLoadRequest {
  ExerciseAnalyticsLoadRequest({required this.range, required DateTime now})
    : now = now.toUtc();

  final ExerciseAnalyticsRange range;
  final DateTime now;

  ExerciseAnalyticsPeriod get period => range.periodEndingAt(now);
}

final class UseCaseExerciseAnalyticsLoader implements ExerciseAnalyticsLoader {
  const UseCaseExerciseAnalyticsLoader({
    required this.getExerciseAnalytics,
    required this.exerciseRef,
  });

  final GetExerciseAnalytics getExerciseAnalytics;
  final ExerciseRef exerciseRef;

  @override
  Future<ExerciseAnalyticsReadModel> load(
    ExerciseAnalyticsLoadRequest request,
  ) {
    return getExerciseAnalytics(
      ExerciseAnalyticsQuery(exerciseRef: exerciseRef, period: request.period),
    );
  }
}
