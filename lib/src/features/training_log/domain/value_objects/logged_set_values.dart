import 'training_log_validation.dart';

final class Repetitions {
  Repetitions(int value) : value = requirePositiveInt('repetitions', value);

  final int value;

  @override
  bool operator ==(Object other) {
    return other is Repetitions && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

final class LoadKg {
  LoadKg(num value) : value = requireNonNegativeFiniteLoadKg('loadKg', value);

  final double value;

  @override
  bool operator ==(Object other) {
    return other is LoadKg && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '$value kg';
}

final class PerformedAt {
  const PerformedAt(this.value);

  final DateTime value;

  @override
  bool operator ==(Object other) {
    return other is PerformedAt && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toIso8601String();
}

final class SetComment {
  SetComment(String value) : value = requireNonBlank('setComment', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is SetComment && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
