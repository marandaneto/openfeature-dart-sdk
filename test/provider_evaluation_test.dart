import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

void main() {
  final providerEval = ProviderEvaluation<bool>(
    true,
    Reason.disabled,
    variant: 'variant',
    errorCode: ErrorCode.flagNotFound,
    errorMessage: 'error',
  );

  test('provider returns value', () {
    expect(providerEval.value, true);
  });

  test('provider returns reason', () {
    expect(providerEval.reason, Reason.disabled);
  });

  test('provider returns variant', () {
    expect(providerEval.variant, 'variant');
  });

  test('provider returns error code', () {
    expect(providerEval.errorCode, ErrorCode.flagNotFound);
  });

  test('provider returns error message', () {
    expect(providerEval.errorMessage, 'error');
  });
}
