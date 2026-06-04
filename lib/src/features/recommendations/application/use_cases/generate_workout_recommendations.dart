import '../../domain/recommendations_domain.dart';

final class GenerateWorkoutRecommendations {
  const GenerateWorkoutRecommendations({required this.engine});

  final RecommendationEngine engine;

  RecommendationPlan call(RecommendationRequest request) {
    return engine.generate(request);
  }
}
