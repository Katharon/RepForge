import '../../../../shared/data/local/repforge_database.dart';
import '../../domain/recovery_domain.dart';

final class ReadinessCheckInMapper {
  const ReadinessCheckInMapper._();

  static ReadinessCheckInsCompanion toCompanion(ReadinessCheckIn checkIn) {
    return ReadinessCheckInsCompanion.insert(
      readinessCheckInId: checkIn.id.value,
      checkedInAt: checkIn.checkedInAt.toUtc(),
      soreness: checkIn.soreness.value,
      sleepQuality: checkIn.sleepQuality.value,
      energy: checkIn.energy.value,
      stress: checkIn.stress.value,
      motivation: checkIn.motivation.value,
    );
  }

  static ReadinessCheckIn toDomain(ReadinessCheckInRow row) {
    return ReadinessCheckIn(
      id: ReadinessCheckInId(row.readinessCheckInId),
      checkedInAt: row.checkedInAt.toUtc(),
      soreness: SorenessRating(row.soreness),
      sleepQuality: SleepQualityRating(row.sleepQuality),
      energy: EnergyRating(row.energy),
      stress: StressRating(row.stress),
      motivation: MotivationRating(row.motivation),
    );
  }
}
