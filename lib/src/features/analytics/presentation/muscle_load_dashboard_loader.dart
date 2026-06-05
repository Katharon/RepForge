import 'package:repforge/src/features/analytics/application/analytics_application.dart';

import 'exercise_analytics_loader.dart';

abstract interface class MuscleLoadDashboardLoader {
  Future<MuscleLoadDashboardReadModel> load(
    MuscleLoadDashboardLoadRequest request,
  );
}

final class MuscleLoadDashboardLoadRequest {
  MuscleLoadDashboardLoadRequest({required DateTime now}) : now = now.toUtc();

  final DateTime now;
}

final class UseCaseMuscleLoadDashboardLoader
    implements MuscleLoadDashboardLoader {
  const UseCaseMuscleLoadDashboardLoader({
    required this.getMuscleLoadDashboard,
    this.ensureCatalogImported,
  });

  final GetMuscleLoadDashboard getMuscleLoadDashboard;
  final Future<void> Function()? ensureCatalogImported;

  @override
  Future<MuscleLoadDashboardReadModel> load(
    MuscleLoadDashboardLoadRequest request,
  ) async {
    await ensureCatalogImported?.call();

    return getMuscleLoadDashboard(MuscleLoadDashboardQuery(now: request.now));
  }
}

typedef MuscleLoadDashboardNowProvider = AnalyticsNowProvider;
