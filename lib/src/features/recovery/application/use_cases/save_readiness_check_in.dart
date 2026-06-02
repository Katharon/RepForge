import '../../domain/recovery_domain.dart';

final class SaveReadinessCheckIn {
  const SaveReadinessCheckIn(this._repository);

  final ReadinessCheckInRepository _repository;

  Future<void> call(ReadinessCheckIn checkIn) {
    return _repository.save(checkIn);
  }
}
