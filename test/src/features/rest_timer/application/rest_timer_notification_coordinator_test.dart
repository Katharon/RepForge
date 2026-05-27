import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/rest_timer/application/rest_timer_application.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';

void main() {
  late _FakeTimeProvider clock;
  late _FakeRestTimerNotificationGateway gateway;
  late RestTimerNotificationCoordinator coordinator;

  setUp(() {
    clock = _FakeTimeProvider(DateTime.utc(2026, 5, 27, 12));
    gateway = _FakeRestTimerNotificationGateway();
    coordinator = RestTimerNotificationCoordinator(
      timerController: RestTimerController(timeProvider: clock),
      notificationGateway: gateway,
    );
  });

  test('start requests permission and schedules timer completion', () async {
    final snapshot = await coordinator.start(
      RestTimerDuration(const Duration(seconds: 90)),
      content: _content,
    );

    expect(snapshot.status, RestTimerStatus.running);
    expect(gateway.permissionRequests, 1);
    expect(gateway.scheduledRequests, hasLength(1));
    expect(
      gateway.scheduledRequests.single.notificationId,
      RestTimerNotificationCoordinator.defaultNotificationId,
    );
    expect(
      gateway.scheduledRequests.single.targetAt,
      DateTime.utc(2026, 5, 27, 12, 1, 30),
    );
    expect(gateway.scheduledRequests.single.content, _content);
  });

  test('denied permission does not schedule', () async {
    gateway.permissionStatus = RestTimerNotificationPermissionStatus.denied;

    await coordinator.start(
      RestTimerDuration(const Duration(seconds: 90)),
      content: _content,
    );

    expect(gateway.permissionRequests, 1);
    expect(gateway.scheduledRequests, isEmpty);
  });

  test('cancel cancels a scheduled notification', () async {
    await coordinator.start(
      RestTimerDuration(const Duration(seconds: 90)),
      content: _content,
    );

    final snapshot = await coordinator.cancel();

    expect(snapshot.status, RestTimerStatus.cancelled);
    expect(gateway.cancelledNotificationIds, <int>[
      RestTimerNotificationCoordinator.defaultNotificationId,
    ]);
  });

  test('reset cancels a scheduled notification', () async {
    await coordinator.start(
      RestTimerDuration(const Duration(seconds: 90)),
      content: _content,
    );

    final snapshot = await coordinator.reset();

    expect(snapshot.status, RestTimerStatus.idle);
    expect(gateway.cancelledNotificationIds, <int>[
      RestTimerNotificationCoordinator.defaultNotificationId,
    ]);
  });

  test(
    'tick cancels scheduled notification when timer finished in app',
    () async {
      await coordinator.start(
        RestTimerDuration(const Duration(seconds: 90)),
        content: _content,
      );
      clock.advance(const Duration(seconds: 95));

      final snapshot = await coordinator.tick();

      expect(snapshot.status, RestTimerStatus.finished);
      expect(gateway.cancelledNotificationIds, <int>[
        RestTimerNotificationCoordinator.defaultNotificationId,
      ]);
    },
  );

  test(
    'restarting cancels previous notification before scheduling new one',
    () async {
      await coordinator.start(
        RestTimerDuration(const Duration(seconds: 90)),
        content: _content,
      );
      clock.advance(const Duration(seconds: 10));

      await coordinator.start(
        RestTimerDuration(const Duration(seconds: 120)),
        content: _content,
      );

      expect(gateway.cancelledNotificationIds, <int>[
        RestTimerNotificationCoordinator.defaultNotificationId,
      ]);
      expect(gateway.scheduledRequests, hasLength(2));
      expect(
        gateway.scheduledRequests.last.targetAt,
        DateTime.utc(2026, 5, 27, 12, 2, 10),
      );
    },
  );
}

const _content = RestTimerNotificationContent(
  title: 'Rest complete',
  body: 'Time for the next set.',
);

final class _FakeTimeProvider implements TimeProvider {
  _FakeTimeProvider(this._now);

  DateTime _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }

  @override
  DateTime now() => _now;
}

final class _FakeRestTimerNotificationGateway
    implements RestTimerNotificationGateway {
  RestTimerNotificationPermissionStatus permissionStatus =
      RestTimerNotificationPermissionStatus.granted;
  int permissionRequests = 0;
  final List<RestTimerNotificationRequest> scheduledRequests =
      <RestTimerNotificationRequest>[];
  final List<int> cancelledNotificationIds = <int>[];

  @override
  Future<RestTimerNotificationPermissionStatus> requestPermission() async {
    permissionRequests += 1;
    return permissionStatus;
  }

  @override
  Future<void> scheduleRestTimerFinished(
    RestTimerNotificationRequest request,
  ) async {
    scheduledRequests.add(request);
  }

  @override
  Future<void> cancelRestTimer(int notificationId) async {
    cancelledNotificationIds.add(notificationId);
  }
}
