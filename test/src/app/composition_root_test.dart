import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/composition_root.dart';
import 'package:repforge/src/features/rest_timer/application/rest_timer_application.dart';
import 'package:repforge/src/features/training_log/data/repositories/drift_workout_set_repository.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database_factory.dart';

void main() {
  test('builds current app dependencies from an injected database factory', () {
    final dependencies = _composeInMemoryDependencies();

    addTearDown(dependencies.close);

    expect(dependencies.configuration.locale, isNull);
    expect(dependencies.workoutSetRepository, isA<WorkoutSetRepository>());
    expect(dependencies.workoutSetRepository, isA<DriftWorkoutSetRepository>());
    expect(
      dependencies.restTimerNotifications,
      isA<RestTimerNotificationCoordinator>(),
    );
  });

  test('composed repository saves and finds a workout set', () async {
    final dependencies = _composeInMemoryDependencies();

    addTearDown(dependencies.close);

    final set = _set(id: 'composed-set-1');

    await dependencies.workoutSetRepository.save(set);

    expect(
      await dependencies.workoutSetRepository.findById(
        WorkoutSetId('composed-set-1'),
      ),
      set,
    );
  });

  test('close is idempotent for owned dependencies', () async {
    final dependencies = _composeInMemoryDependencies();

    await dependencies.close();
    await dependencies.close();
    await dependencies.close();
  });
}

AppDependencies _composeInMemoryDependencies() {
  return CompositionRoot(
    databaseFactory: RepForgeDatabaseFactory(
      createExecutor: () => NativeDatabase.memory(),
    ),
  ).compose();
}

WorkoutSet _set({required String id}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell-bench-press'),
      displayNameSnapshot: 'Barbell Bench Press',
      catalogVersionSnapshot: '2026.05.0',
    ),
    repetitions: Repetitions(5),
    load: LoadKg(100),
    performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 12)),
  );
}
