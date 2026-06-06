import 'package:flutter/widgets.dart';

import '../../exercise_catalog/presentation/exercise_catalog_presentation.dart';
import '../domain/workout_groups_domain.dart';

abstract interface class WorkoutGroupListLoader {
  Future<WorkoutGroupListViewModel> load();
}

abstract interface class TrainPageLoader {
  Future<TrainLandingViewModel> load({Locale? locale});
}

final class RepositoryTrainPageLoader implements TrainPageLoader {
  const RepositoryTrainPageLoader({
    required this.groupLoader,
    required this.exerciseLoader,
  });

  final WorkoutGroupListLoader groupLoader;
  final ExerciseCatalogListLoader exerciseLoader;

  @override
  Future<TrainLandingViewModel> load({Locale? locale}) async {
    final results = await Future.wait<Object>([
      groupLoader.load(),
      exerciseLoader.load(locale: locale),
    ]);

    final groups = results[0] as WorkoutGroupListViewModel;
    final exercises = results[1] as ExerciseCatalogListViewModel;

    return TrainLandingViewModel.fromExercises(
      exercises: exercises.exercises,
      groups: groups.groups,
      totalGroupCount: groups.totalCount,
    );
  }
}

final class RepositoryWorkoutGroupListLoader implements WorkoutGroupListLoader {
  const RepositoryWorkoutGroupListLoader({
    required this.repository,
    this.limit = 50,
  });

  final WorkoutGroupRepository repository;
  final int limit;

  @override
  Future<WorkoutGroupListViewModel> load() async {
    final page = await repository.listGroups(
      WorkoutGroupQuery(limit: limit, offset: 0),
    );
    final groups = <WorkoutGroupListItemViewModel>[];

    for (final group in page.items) {
      final assignments = await repository.listAssignments(
        group.id,
        WorkoutGroupAssignmentQuery(limit: 100, offset: 0),
      );
      groups.add(
        WorkoutGroupListItemViewModel(
          id: group.id.value,
          name: group.name.value,
          exerciseCount: assignments.totalCount,
          exercises: assignments.items
              .map(
                (assignment) => ExerciseListItemViewModel.fromExerciseRef(
                  assignment.exerciseRef,
                ),
              )
              .toList(growable: false),
          exerciseNames: assignments.items
              .map((assignment) => assignment.exerciseRef.displayNameSnapshot)
              .toList(growable: false),
        ),
      );
    }

    return WorkoutGroupListViewModel(
      groups: List<WorkoutGroupListItemViewModel>.unmodifiable(groups),
      totalCount: page.totalCount,
      hasMore: page.hasMore,
    );
  }
}

final class WorkoutGroupListViewModel {
  const WorkoutGroupListViewModel({
    required this.groups,
    required this.totalCount,
    required this.hasMore,
  });

  final List<WorkoutGroupListItemViewModel> groups;
  final int totalCount;
  final bool hasMore;
}

final class WorkoutGroupListItemViewModel {
  const WorkoutGroupListItemViewModel({
    required this.id,
    required this.name,
    required this.exerciseCount,
    required this.exerciseNames,
    this.exercises = const <ExerciseListItemViewModel>[],
  });

  final String id;
  final String name;
  final int exerciseCount;
  final List<String> exerciseNames;
  final List<ExerciseListItemViewModel> exercises;
}

enum TrainCategoryId {
  myExercises,
  fullBody,
  upperBody,
  lowerBody,
  push,
  pull,
  legs,
  core,
}

final class TrainLandingViewModel {
  const TrainLandingViewModel({
    required this.categories,
    required this.groups,
    required this.totalGroupCount,
  });

  factory TrainLandingViewModel.fromExercises({
    required List<ExerciseListItemViewModel> exercises,
    List<WorkoutGroupListItemViewModel> groups =
        const <WorkoutGroupListItemViewModel>[],
    int totalGroupCount = 0,
  }) {
    return TrainLandingViewModel(
      categories: [
        for (final id in TrainCategoryId.values)
          TrainCategoryViewModel(
            id: id,
            exercises: exercises
                .where((exercise) => _matchesCategory(id, exercise))
                .toList(growable: false),
          ),
      ],
      groups: List<WorkoutGroupListItemViewModel>.unmodifiable(groups),
      totalGroupCount: totalGroupCount,
    );
  }

  final List<TrainCategoryViewModel> categories;
  final List<WorkoutGroupListItemViewModel> groups;
  final int totalGroupCount;

  bool get isEmpty {
    return categories.every((category) => category.exercises.isEmpty) &&
        groups.isEmpty;
  }
}

final class TrainCategoryViewModel {
  const TrainCategoryViewModel({required this.id, required this.exercises});

  final TrainCategoryId id;
  final List<ExerciseListItemViewModel> exercises;

  int get exerciseCount => exercises.length;
}

bool _matchesCategory(TrainCategoryId id, ExerciseListItemViewModel exercise) {
  if (id == TrainCategoryId.myExercises) {
    return true;
  }

  final patterns = exercise.movementPatterns.toSet();
  final muscles = <String>{
    ...exercise.primaryMuscles,
    ...exercise.secondaryMuscles,
  };

  return switch (id) {
    TrainCategoryId.fullBody =>
      _hasAny(patterns, _compoundPatterns) ||
          (_hasAny(muscles, _upperMuscles) && _hasAny(muscles, _lowerMuscles)),
    TrainCategoryId.upperBody =>
      _hasAny(patterns, _upperPatterns) || _hasAny(muscles, _upperMuscles),
    TrainCategoryId.lowerBody =>
      _hasAny(patterns, _lowerPatterns) || _hasAny(muscles, _lowerMuscles),
    TrainCategoryId.push =>
      _hasAny(patterns, _pushPatterns) || _hasAny(muscles, _pushMuscles),
    TrainCategoryId.pull =>
      _hasAny(patterns, _pullPatterns) || _hasAny(muscles, _pullMuscles),
    TrainCategoryId.legs =>
      _hasAny(patterns, _lowerPatterns) || _hasAny(muscles, _legMuscles),
    TrainCategoryId.core =>
      _hasAny(patterns, _corePatterns) || muscles.contains('core'),
    TrainCategoryId.myExercises => true,
  };
}

bool _hasAny(Set<String> values, Set<String> targets) {
  return values.any(targets.contains);
}

const Set<String> _compoundPatterns = <String>{
  'horizontal_push',
  'vertical_push',
  'horizontal_pull',
  'vertical_pull',
  'squat',
  'knee_dominant',
  'hinge',
  'lunge',
};

const Set<String> _upperPatterns = <String>{
  'horizontal_push',
  'vertical_push',
  'horizontal_pull',
  'vertical_pull',
  'elbow_extension',
  'elbow_flexion',
  'accessory_push',
  'accessory_pull',
};

const Set<String> _lowerPatterns = <String>{
  'squat',
  'knee_dominant',
  'hinge',
  'lunge',
};

const Set<String> _pushPatterns = <String>{
  'horizontal_push',
  'vertical_push',
  'elbow_extension',
  'accessory_push',
};

const Set<String> _pullPatterns = <String>{
  'horizontal_pull',
  'vertical_pull',
  'elbow_flexion',
  'accessory_pull',
};

const Set<String> _corePatterns = <String>{'core'};

const Set<String> _upperMuscles = <String>{
  'chest',
  'upper_chest',
  'shoulders',
  'front_deltoids',
  'rear_deltoids',
  'triceps',
  'biceps',
  'lats',
  'upper_back',
  'traps',
  'forearms',
};

const Set<String> _lowerMuscles = <String>{
  'quadriceps',
  'hamstrings',
  'glutes',
  'calves',
  'erector_spinae',
};

const Set<String> _pushMuscles = <String>{
  'chest',
  'upper_chest',
  'shoulders',
  'front_deltoids',
  'triceps',
};

const Set<String> _pullMuscles = <String>{
  'lats',
  'upper_back',
  'rear_deltoids',
  'biceps',
  'forearms',
  'traps',
};

const Set<String> _legMuscles = <String>{
  'quadriceps',
  'hamstrings',
  'glutes',
  'calves',
};
