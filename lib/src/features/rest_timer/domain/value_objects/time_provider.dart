abstract interface class TimeProvider {
  DateTime now();
}

final class SystemTimeProvider implements TimeProvider {
  const SystemTimeProvider();

  @override
  DateTime now() => DateTime.now().toUtc();
}
