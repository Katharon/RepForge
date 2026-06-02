import '../../domain/recovery_domain.dart';
import 'get_latest_readiness.dart';

final class GetTodayReadiness {
  const GetTodayReadiness({
    required this.repository,
    this.calculator = const ReadinessScoreCalculator(),
    this.nowProvider = _systemNow,
  });

  final ReadinessCheckInRepository repository;
  final ReadinessScoreCalculator calculator;
  final ReadinessNowProvider nowProvider;

  Future<ReadinessReadModel> call() async {
    final now = nowProvider().toLocal();
    final dayStart = DateTime(now.year, now.month, now.day);
    final checkIn = await repository.latestForRange(
      startInclusive: dayStart,
      endExclusive: dayStart.add(const Duration(days: 1)),
    );
    if (checkIn == null) {
      return ReadinessReadModel.empty(forDate: dayStart);
    }

    final result = calculator.calculate(checkIn);
    return ReadinessReadModel(
      status: ReadinessReadModelStatus.available,
      forDate: dayStart,
      confidence: result.confidence,
      latestCheckIn: checkIn,
      score: result.score,
      level: result.level,
      reasons: result.reasons,
    );
  }
}

DateTime _systemNow() => DateTime.now();
