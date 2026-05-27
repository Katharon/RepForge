import 'dart:async';
import 'dart:ui';

import '../features/rest_timer/application/rest_timer_application.dart';
import '../features/rest_timer/data/rest_timer_data.dart';
import '../features/rest_timer/domain/rest_timer_domain.dart';
import '../features/training_log/data/repositories/drift_workout_set_repository.dart';
import '../features/training_log/domain/training_log_domain.dart';
import '../shared/data/local/repforge_database.dart';
import '../shared/data/local/repforge_database_factory.dart';

final class AppConfiguration {
  const AppConfiguration({this.locale});

  final Locale? locale;
}

final class AppDependencies {
  AppDependencies({
    required this.configuration,
    required this.workoutSetRepository,
    required this.restTimerNotifications,
  }) : _closeOwnedResources = null;

  AppDependencies._withOwnedResources({
    required this.configuration,
    required this.workoutSetRepository,
    required this.restTimerNotifications,
    required this._closeOwnedResources,
  });

  final AppConfiguration configuration;
  final WorkoutSetRepository workoutSetRepository;
  final RestTimerNotificationCoordinator restTimerNotifications;

  final Future<void> Function()? _closeOwnedResources;
  Future<void>? _closeOperation;

  /// Closes resources owned by this dependency object.
  ///
  /// Resources created by [CompositionRoot.compose] are owned by this object.
  /// Supplied database instances are closed only when ownership is explicitly
  /// enabled by the caller.
  /// Calling this method more than once is safe; owned resources are closed at
  /// most once.
  Future<void> close() {
    final closeOwnedResources = _closeOwnedResources;
    if (closeOwnedResources == null) {
      return Future<void>.value();
    }

    final existingClose = _closeOperation;
    if (existingClose != null) {
      return existingClose;
    }

    final completer = Completer<void>.sync();
    _closeOperation = completer.future;

    unawaited(
      Future<void>.sync(
        closeOwnedResources,
      ).then(completer.complete, onError: completer.completeError),
    );

    return completer.future;
  }
}

final class CompositionRoot {
  const CompositionRoot({
    this.configuration = const AppConfiguration(),
    this.databaseFactory = const RepForgeDatabaseFactory(),
    this.database,
    this.ownsDatabase,
    this.restTimerNotificationGateway,
  });

  final AppConfiguration configuration;
  final RepForgeDatabaseFactory databaseFactory;
  final RepForgeDatabase? database;
  final bool? ownsDatabase;
  final RestTimerNotificationGateway? restTimerNotificationGateway;

  AppDependencies compose() {
    final composedDatabase = database ?? databaseFactory.createDatabase();
    final workoutSetRepository = DriftWorkoutSetRepository(composedDatabase);
    final restTimerNotifications = RestTimerNotificationCoordinator(
      timerController: RestTimerController(
        timeProvider: const SystemTimeProvider(),
      ),
      notificationGateway:
          restTimerNotificationGateway ??
          FlutterLocalRestTimerNotificationGateway(),
    );
    final shouldOwnDatabase = ownsDatabase ?? (database == null);

    if (!shouldOwnDatabase) {
      return AppDependencies(
        configuration: configuration,
        workoutSetRepository: workoutSetRepository,
        restTimerNotifications: restTimerNotifications,
      );
    }

    return AppDependencies._withOwnedResources(
      configuration: configuration,
      workoutSetRepository: workoutSetRepository,
      restTimerNotifications: restTimerNotifications,
      closeOwnedResources: composedDatabase.close,
    );
  }
}
