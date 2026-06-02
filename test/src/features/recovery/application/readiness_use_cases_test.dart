import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/recovery/application/recovery_application.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';

void main() {
  group('Readiness use cases', () {
    test('empty state returns no latest readiness check-in', () async {
      final repository = _InMemoryReadinessCheckInRepository();
      final latest = await GetLatestReadiness(repository).call();

      expect(latest.status, ReadinessReadModelStatus.empty);
      expect(latest.latestCheckIn, isNull);
      expect(latest.allowsWorkoutLogging, isTrue);
    });

    test('save delegates valid check-in and latest returns score', () async {
      final repository = _InMemoryReadinessCheckInRepository();
      final checkIn = _checkIn('saved', DateTime.utc(2026, 6, 2, 8));

      await SaveReadinessCheckIn(repository).call(checkIn);
      final latest = await GetLatestReadiness(repository).call();

      expect(latest.status, ReadinessReadModelStatus.available);
      expect(latest.latestCheckIn, checkIn);
      expect(latest.score, isNotNull);
      expect(latest.confidence, ReadinessConfidence.reported);
    });

    test('today lookup filters by local date range', () async {
      final repository = _InMemoryReadinessCheckInRepository();
      await repository.save(
        _checkIn('yesterday', DateTime.utc(2026, 6, 1, 22)),
      );
      await repository.save(_checkIn('today', DateTime.utc(2026, 6, 2, 7)));

      final today = await GetTodayReadiness(
        repository: repository,
        nowProvider: () => DateTime.utc(2026, 6, 2, 12),
      ).call();

      expect(today.status, ReadinessReadModelStatus.available);
      expect(today.latestCheckIn?.id, ReadinessCheckInId('today'));
    });

    test('high soreness readiness never blocks logging', () async {
      final repository = _InMemoryReadinessCheckInRepository();
      await SaveReadinessCheckIn(repository).call(
        ReadinessCheckIn(
          id: ReadinessCheckInId('sore'),
          checkedInAt: DateTime.utc(2026, 6, 2, 8),
          soreness: SorenessRating.veryHigh(),
          sleepQuality: SleepQualityRating(2),
          energy: EnergyRating(2),
          stress: StressRating(5),
          motivation: MotivationRating(2),
        ),
      );

      final readiness = await GetLatestReadiness(repository).call();

      expect(readiness.level, ReadinessLevel.veryLow);
      expect(readiness.allowsWorkoutLogging, isTrue);
    });
  });
}

ReadinessCheckIn _checkIn(String id, DateTime checkedInAt) {
  return ReadinessCheckIn(
    id: ReadinessCheckInId(id),
    checkedInAt: checkedInAt,
    soreness: SorenessRating.light(),
    sleepQuality: SleepQualityRating(4),
    energy: EnergyRating(4),
    stress: StressRating(2),
    motivation: MotivationRating(4),
  );
}

final class _InMemoryReadinessCheckInRepository
    implements ReadinessCheckInRepository {
  final _items = <ReadinessCheckIn>[];

  @override
  Future<ReadinessCheckIn?> latest() async {
    if (_items.isEmpty) {
      return null;
    }
    final sorted = [..._items]
      ..sort((left, right) {
        final byDate = right.checkedInAt.compareTo(left.checkedInAt);
        if (byDate != 0) {
          return byDate;
        }
        return right.id.value.compareTo(left.id.value);
      });
    return sorted.first;
  }

  @override
  Future<ReadinessCheckIn?> latestForRange({
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) async {
    final matching = _items
        .where(
          (item) =>
              !item.checkedInAt.isBefore(startInclusive) &&
              item.checkedInAt.isBefore(endExclusive),
        )
        .toList();
    if (matching.isEmpty) {
      return null;
    }
    matching.sort((left, right) {
      final byDate = right.checkedInAt.compareTo(left.checkedInAt);
      if (byDate != 0) {
        return byDate;
      }
      return right.id.value.compareTo(left.id.value);
    });
    return matching.first;
  }

  @override
  Future<void> save(ReadinessCheckIn checkIn) async {
    _items.removeWhere((item) => item.id == checkIn.id);
    _items.add(checkIn);
  }
}
