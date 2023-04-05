import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

void main() {
  final noOp = NoOpProvider();

  test('return default bool value', () {
    final eval = noOp.getBooleanEvaluation('key', true);

    expect(eval.value, true);
  });

  test('return default string value', () {
    final eval = noOp.getStringEvaluation('key', 'value');

    expect(eval.value, 'value');
  });

  test('return default num value', () {
    final eval = noOp.getNumberEvaluation('key', 1);

    expect(eval.value, 1);
  });

  test('return default object value', () {
    final value = Value.fromObject('1');
    final eval = noOp.getObjectEvaluation('key', value);

    expect(eval.value.asString, '1');
  });
}
