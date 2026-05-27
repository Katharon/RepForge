import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/training_log/application/training_log_application.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  late _InMemoryWorkoutSetRepository repository;
  late SaveWorkoutSet saveWorkoutSet;
  late UpdateWorkoutSet updateWorkoutSet;
  late DeleteWorkoutSet deleteWorkoutSet;

  setUp(() {
    repository = _InMemoryWorkoutSetRepository();
    saveWorkoutSet = SaveWorkoutSet(repository);
    updateWorkoutSet = UpdateWorkoutSet(repository);
    deleteWorkoutSet = DeleteWorkoutSet(repository);
  });

  test('creates a valid workout set from compact form input', () async {
    final exerciseRef = _exerciseRef(displayNameSnapshot: 'Bench Press');
    final form = WorkoutSetForm(
      targetExerciseRef: exerciseRef,
      loadKgInput: '100.5',
      repetitionsInput: '5',
      performedAt: DateTime.utc(2026, 5, 27, 10, 30),
      commentInput: ' Top set ',
    );

    final saved = await saveWorkoutSet(
      form,
      workoutSetId: WorkoutSetId('set-1'),
    );

    expect(saved.id, WorkoutSetId('set-1'));
    expect(saved.exerciseRef, exerciseRef);
    expect(saved.repetitions, Repetitions(5));
    expect(saved.load, LoadKg(100.5));
    expect(saved.performedAt, PerformedAt(DateTime.utc(2026, 5, 27, 10, 30)));
    expect(saved.comment, SetComment('Top set'));
    expect(await repository.findById(WorkoutSetId('set-1')), saved);
  });

  test(
    'updates an existing workout set while preserving id and ExerciseRef snapshot',
    () async {
      final originalExerciseRef = _exerciseRef(
        displayNameSnapshot: 'Old Bench Name',
      );
      final existing = WorkoutSet(
        id: WorkoutSetId('set-edit'),
        exerciseRef: originalExerciseRef,
        workoutSessionId: WorkoutSessionId('session-1'),
        repetitions: Repetitions(5),
        load: LoadKg(100),
        performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 10)),
        comment: SetComment('Original'),
      );
      await repository.save(existing);

      final updated = await updateWorkoutSet(
        WorkoutSetForm(
          existingWorkoutSetId: existing.id,
          targetExerciseRef: _exerciseRef(
            displayNameSnapshot: 'Current Bench Name',
            catalogVersionSnapshot: '2026.06.0',
          ),
          loadKgInput: '102.5',
          repetitionsInput: '6',
          performedAt: DateTime.utc(2026, 5, 28, 11),
          commentInput: 'Smooth',
        ),
      );

      expect(updated.id, existing.id);
      expect(updated.exerciseRef, originalExerciseRef);
      expect(updated.workoutSessionId, existing.workoutSessionId);
      expect(updated.repetitions, Repetitions(6));
      expect(updated.load, LoadKg(102.5));
      expect(updated.performedAt, PerformedAt(DateTime.utc(2026, 5, 28, 11)));
      expect(updated.comment, SetComment('Smooth'));
      expect(await repository.findById(existing.id), updated);
    },
  );

  test('deletes a workout set by stable id', () async {
    final set = _set(id: 'set-delete');
    await repository.save(set);

    await deleteWorkoutSet(WorkoutSetId('set-delete'));

    expect(await repository.findById(WorkoutSetId('set-delete')), isNull);
  });

  test('rejects invalid repetitions through domain validation', () {
    final form = _form(repetitionsInput: '0');

    expect(
      () => form.toNewWorkoutSet(workoutSetId: WorkoutSetId('set-invalid')),
      throwsA(
        isA<TrainingLogValidationException>().having(
          (TrainingLogValidationException error) => error.field,
          'field',
          'repetitions',
        ),
      ),
    );
  });

  test('rejects negative or non-finite load through domain validation', () {
    expect(
      () => _form(
        loadKgInput: '-1',
      ).toNewWorkoutSet(workoutSetId: WorkoutSetId('set-negative')),
      throwsA(isA<TrainingLogValidationException>()),
    );
    expect(
      () => _form(
        loadKgInput: 'NaN',
      ).toNewWorkoutSet(workoutSetId: WorkoutSetId('set-nan')),
      throwsA(isA<TrainingLogValidationException>()),
    );
    expect(
      () => _form(
        loadKgInput: 'Infinity',
      ).toNewWorkoutSet(workoutSetId: WorkoutSetId('set-infinity')),
      throwsA(isA<TrainingLogValidationException>()),
    );
  });

  test('treats blank optional comments as absent', () {
    final set = _form(
      commentInput: '   ',
    ).toNewWorkoutSet(workoutSetId: WorkoutSetId('set-blank-comment'));

    expect(set.comment, isNull);
  });
}

WorkoutSetForm _form({
  String loadKgInput = '100',
  String repetitionsInput = '5',
  String? commentInput,
}) {
  return WorkoutSetForm(
    targetExerciseRef: _exerciseRef(),
    loadKgInput: loadKgInput,
    repetitionsInput: repetitionsInput,
    performedAt: DateTime.utc(2026, 5, 27, 12),
    commentInput: commentInput,
  );
}

WorkoutSet _set({required String id}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: _exerciseRef(),
    repetitions: Repetitions(5),
    load: LoadKg(100),
    performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 12)),
  );
}

ExerciseRef _exerciseRef({
  String displayNameSnapshot = 'Barbell Bench Press',
  String catalogVersionSnapshot = '2026.05.0',
}) {
  return ExerciseRef.official(
    id: OfficialExerciseId('barbell-bench-press'),
    displayNameSnapshot: displayNameSnapshot,
    catalogVersionSnapshot: catalogVersionSnapshot,
  );
}

final class _InMemoryWorkoutSetRepository implements WorkoutSetRepository {
  final Map<WorkoutSetId, WorkoutSet> _sets = <WorkoutSetId, WorkoutSet>{};

  @override
  Future<void> save(WorkoutSet set) async {
    _sets[set.id] = set;
  }

  @override
  Future<void> deleteById(WorkoutSetId id) async {
    _sets.remove(id);
  }

  @override
  Future<WorkoutSet?> findById(WorkoutSetId id) async => _sets[id];

  @override
  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef) async {
    return _sets.values
        .where((WorkoutSet set) => set.exerciseRef == exerciseRef)
        .toList(growable: false);
  }

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) async {
    final items = await historyForExercise(query.exerciseRef);
    return WorkoutSetTimelinePage(
      items: items.take(query.limit),
      hasMore: items.length > query.limit,
      nextCursor: items.length > query.limit && items.isNotEmpty
          ? WorkoutSetTimelineCursor.fromSet(items.take(query.limit).last)
          : null,
    );
  }

  @override
  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  ) async {
    return _sets.values
        .where((WorkoutSet set) => set.workoutSessionId == workoutSessionId)
        .toList(growable: false);
  }
}
