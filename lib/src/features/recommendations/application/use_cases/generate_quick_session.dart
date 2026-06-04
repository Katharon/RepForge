import '../../domain/recommendations_domain.dart';

final class GenerateQuickSession {
  const GenerateQuickSession({required this.generator});

  final QuickSessionGenerator generator;

  QuickSessionPlan call(QuickSessionRequest request) {
    return generator.generate(request);
  }
}
