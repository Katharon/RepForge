final class PeriodComparison {
  const PeriodComparison({
    required this.current,
    required this.previous,
    required this.absoluteDelta,
    required this.percentChange,
  });

  factory PeriodComparison.fromValues({required num current, num? previous}) {
    final currentValue = current.toDouble();
    final previousValue = previous?.toDouble();
    final absoluteDelta = previousValue == null
        ? null
        : currentValue - previousValue;
    final percentChange = previousValue == null || previousValue == 0
        ? null
        : absoluteDelta! / previousValue;

    return PeriodComparison(
      current: currentValue,
      previous: previousValue,
      absoluteDelta: absoluteDelta,
      percentChange: percentChange,
    );
  }

  final double current;
  final double? previous;
  final double? absoluteDelta;
  final double? percentChange;

  bool get hasPrevious => previous != null;

  @override
  bool operator ==(Object other) {
    return other is PeriodComparison &&
        other.current == current &&
        other.previous == previous &&
        other.absoluteDelta == absoluteDelta &&
        other.percentChange == percentChange;
  }

  @override
  int get hashCode {
    return Object.hash(current, previous, absoluteDelta, percentChange);
  }
}
