import '../entities/readiness_check_in.dart';

abstract interface class ReadinessCheckInRepository {
  Future<void> save(ReadinessCheckIn checkIn);

  Future<ReadinessCheckIn?> latest();

  Future<ReadinessCheckIn?> latestForRange({
    required DateTime startInclusive,
    required DateTime endExclusive,
  });
}
