import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

void main() {
  final eval = ProviderEvaluation<String>(
    'defaultValue',
    Reason.static,
    variant: 'variant',
    errorCode: ErrorCode.flagNotFound,
    errorMessage: 'error',
  );
  final details = FlagEvaluationDetails.from<String>(eval, 'flagKey');

  test('details returns key', () {
    expect(details.key, 'flagKey');
  });

  test('details returns value', () {
    expect(details.value, 'defaultValue');
  });

  test('details returns reason', () {
    expect(details.reason, Reason.static);
  });

  test('details returns variant', () {
    expect(details.variant, 'variant');
  });

  test('details returns error code', () {
    expect(details.errorCode, ErrorCode.flagNotFound);
  });

  test('details returns error message', () {
    expect(details.errorMessage, 'error');
  });
}
