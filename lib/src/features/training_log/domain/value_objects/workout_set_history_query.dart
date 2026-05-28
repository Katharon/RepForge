import '../entities/workout_set.dart';
import '../exceptions/training_log_validation_exception.dart';
import 'set_label.dart';
import 'training_log_validation.dart';

enum WorkoutSetHistorySort { newestFirst, oldestFirst }

final class WorkoutSetHistoryQuery {
  WorkoutSetHistoryQuery({
    required int limit,
    required int offset,
    String? searchText,
    Iterable<WorkoutSetLabel> labels = const <WorkoutSetLabel>[],
    this.sort = WorkoutSetHistorySort.newestFirst,
  }) : limit = _requireHistoryLimit(limit),
       offset = _requireHistoryOffset(offset),
       searchText = _normalizeSearchText(searchText),
       labels = List<WorkoutSetLabel>.unmodifiable(labels);

  final int limit;
  final int offset;
  final String? searchText;
  final List<WorkoutSetLabel> labels;
  final WorkoutSetHistorySort sort;
}

final class WorkoutSetHistoryPage {
  WorkoutSetHistoryPage({
    required Iterable<WorkoutSet> items,
    required this.totalCount,
    required this.limit,
    required this.offset,
  }) : items = List<WorkoutSet>.unmodifiable(items);

  final List<WorkoutSet> items;
  final int totalCount;
  final int limit;
  final int offset;

  bool get hasMore => offset + items.length < totalCount;
}

int _requireHistoryLimit(int value) {
  if (value <= 0 || value > 100) {
    throw TrainingLogValidationException(
      'workoutSetHistory.limit',
      'Must be between 1 and 100.',
    );
  }

  return value;
}

int _requireHistoryOffset(int value) {
  if (value < 0) {
    throw TrainingLogValidationException(
      'workoutSetHistory.offset',
      'Must not be negative.',
    );
  }

  return value;
}

String? _normalizeSearchText(String? value) {
  if (value == null) {
    return null;
  }

  final trimmed = value.trim();
  return trimmed.isEmpty
      ? null
      : requireNonBlank('workoutSetHistory.searchText', value);
}
