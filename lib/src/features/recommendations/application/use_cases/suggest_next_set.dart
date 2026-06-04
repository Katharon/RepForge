import '../../domain/recommendations_domain.dart';

final class SuggestNextSet {
  const SuggestNextSet({required this.suggester});

  final AdaptiveSetSuggester suggester;

  AdaptiveSetSuggestion call(AdaptiveSetSuggestionRequest request) {
    return suggester.suggest(request);
  }
}
