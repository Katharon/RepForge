import '../../domain/recovery_domain.dart';

typedef ReadinessNowProvider = DateTime Function();

final class GetLatestReadiness {
  const GetLatestReadiness(
    this._repository, {
    this._calculator = const ReadinessScoreCalculator(),
    this._nowProvider = _systemNow,
  });

  final ReadinessCheckInRepository _repository;
  final ReadinessScoreCalculator _calculator;
  final ReadinessNowProvider _nowProvider;

  Future<ReadinessReadModel> call() async {
    final checkIn = await _repository.latest();
    if (checkIn == null) {
      return ReadinessReadModel.empty(forDate: _nowProvider().toUtc());
    }

    final result = _calculator.calculate(checkIn);
    return ReadinessReadModel(
      status: ReadinessReadModelStatus.available,
      forDate: checkIn.checkedInAt,
      confidence: result.confidence,
      latestCheckIn: checkIn,
      score: result.score,
      level: result.level,
      reasons: result.reasons,
    );
  }
}

DateTime _systemNow() => DateTime.now();
