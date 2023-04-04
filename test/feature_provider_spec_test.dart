import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

void main() {
  final noOp = NoOpProvider();

  test('provider must define a name, 2.1.1', () {
    expect(noOp.metadata.name, 'No-op Provider');
  });

  test(
      'provider must define methods for typed flag resolution, 2.2.2.1, 2.2.3, 2.2.1',
      () {
    final eval = noOp.getBooleanEvaluation('key', true,
        evaluationContext: ImmutableContext.empty());

    expect(eval.value, true);
  });

  test('provider should populate the resolution details reason field, 2.2.5',
      () {
    final eval = noOp.getBooleanEvaluation('key', true,
        evaluationContext: ImmutableContext.empty());

    expect(eval.reason, Reason.defaultReason);
  });
}
