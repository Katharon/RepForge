import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/recommendations/application/recommendations_application.dart';
import 'package:repforge/src/features/recommendations/domain/recommendations_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  test('SuggestNextSet delegates to injected adaptive set suggester', () {
    final suggester = _FakeAdaptiveSetSuggester(
      AdaptiveSetSuggestion(
        direction: AdaptiveSetDirection.maintain,
        inputQuality: AdaptiveSetInputQuality.partial,
        exerciseRef: _ref(),
        currentLoad: LoadKg(40),
        currentRepetitions: Repetitions(8),
        suggestedLoad: LoadKg(40),
        suggestedRepetitions: Repetitions(8),
        reasons: const <AdaptiveSetReasonCode>[
          AdaptiveSetReasonCode.noBaseline,
        ],
      ),
    );
    final useCase = SuggestNextSet(suggester: suggester);
    final request = AdaptiveSetSuggestionRequest(
      currentSet: CurrentSetPerformance(
        exerciseRef: _ref(),
        load: LoadKg(40),
        repetitions: Repetitions(8),
      ),
    );

    final suggestion = useCase(request);

    expect(suggestion.direction, AdaptiveSetDirection.maintain);
    expect(suggester.requests.single, request);
  });
}

final class _FakeAdaptiveSetSuggester implements AdaptiveSetSuggester {
  _FakeAdaptiveSetSuggester(this.suggestion);

  final AdaptiveSetSuggestion suggestion;
  final List<AdaptiveSetSuggestionRequest> requests =
      <AdaptiveSetSuggestionRequest>[];

  @override
  AdaptiveSetSuggestion suggest(AdaptiveSetSuggestionRequest request) {
    requests.add(request);
    return suggestion;
  }
}

ExerciseRef _ref() {
  return ExerciseRef.official(
    id: OfficialExerciseId('bench'),
    displayNameSnapshot: 'Bench Press',
    catalogVersionSnapshot: '2026.06.0',
  );
}
