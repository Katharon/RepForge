import '../value_objects/readiness_values.dart';

final class ReadinessCheckIn {
  ReadinessCheckIn({
    required this.id,
    required DateTime checkedInAt,
    required this.soreness,
    required this.sleepQuality,
    required this.energy,
    required this.stress,
    required this.motivation,
  }) : checkedInAt = checkedInAt.toUtc();

  final ReadinessCheckInId id;
  final DateTime checkedInAt;
  final SorenessRating soreness;
  final SleepQualityRating sleepQuality;
  final EnergyRating energy;
  final StressRating stress;
  final MotivationRating motivation;

  @override
  bool operator ==(Object other) {
    return other is ReadinessCheckIn &&
        other.id == id &&
        other.checkedInAt == checkedInAt &&
        other.soreness == soreness &&
        other.sleepQuality == sleepQuality &&
        other.energy == energy &&
        other.stress == stress &&
        other.motivation == motivation;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      checkedInAt,
      soreness,
      sleepQuality,
      energy,
      stress,
      motivation,
    );
  }
}
