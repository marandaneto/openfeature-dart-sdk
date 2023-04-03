import 'package:openfeature_dart/openfeature.dart';
import 'package:test/test.dart';

void main() {
  final noOp = NoOpProvider();

  test('return default bool value', () {
    ProviderEvaluation<bool> eval =
        noOp.getBooleanEvaluation('key', defaultValue: true);

    expect(eval.getValue(), true);
  });
}
