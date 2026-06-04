import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/recommendations/application/recommendations_application.dart';
import 'package:repforge/src/features/recommendations/domain/recommendations_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

void main() {
  test('GenerateQuickSession delegates to injected generator', () {
    final generator = _FakeQuickSessionGenerator(
      QuickSessionPlan.unavailable(
        duration: QuickSessionDuration.fifteen,
        recommendationPlan: RecommendationPlan.unavailable(
          inputReasons: const <RecommendationReasonCode>[
            RecommendationReasonCode.candidateListEmpty,
          ],
        ),
        reasons: const <QuickSessionReasonCode>[
          QuickSessionReasonCode.candidateListEmpty,
        ],
      ),
    );
    final useCase = GenerateQuickSession(generator: generator);

    final request = QuickSessionRequest(
      duration: QuickSessionDuration.fifteen,
      recommendationRequest: RecommendationRequest(
        candidates: const <RecommendationCandidate>[],
        settingsProfile: SettingsProfile.defaults(),
      ),
    );

    final plan = useCase(request);

    expect(plan.status, QuickSessionPlanStatus.unavailable);
    expect(generator.requests.single, request);
  });
}

final class _FakeQuickSessionGenerator implements QuickSessionGenerator {
  _FakeQuickSessionGenerator(this.plan);

  final QuickSessionPlan plan;
  final List<QuickSessionRequest> requests = <QuickSessionRequest>[];

  @override
  QuickSessionPlan generate(QuickSessionRequest request) {
    requests.add(request);
    return plan;
  }
}
