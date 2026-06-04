import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/recommendations/application/recommendations_application.dart';
import 'package:repforge/src/features/recommendations/domain/recommendations_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

void main() {
  test('GenerateWorkoutRecommendations delegates to injected engine', () {
    final engine = _FakeRecommendationEngine(
      RecommendationPlan.unavailable(
        inputReasons: const <RecommendationReasonCode>[
          RecommendationReasonCode.candidateListEmpty,
        ],
      ),
    );
    final useCase = GenerateWorkoutRecommendations(engine: engine);

    final request = RecommendationRequest(
      candidates: const <RecommendationCandidate>[],
      settingsProfile: SettingsProfile.defaults(),
    );

    final plan = useCase(request);

    expect(plan.status, RecommendationPlanStatus.unavailable);
    expect(engine.requests.single, request);
  });
}

final class _FakeRecommendationEngine implements RecommendationEngine {
  _FakeRecommendationEngine(this.plan);

  final RecommendationPlan plan;
  final List<RecommendationRequest> requests = <RecommendationRequest>[];

  @override
  RecommendationPlan generate(RecommendationRequest request) {
    requests.add(request);
    return plan;
  }
}
