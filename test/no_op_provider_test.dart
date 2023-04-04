import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

void main() {
  final noOp = NoOpProvider();

  test('return default bool value', () {
    final eval = noOp.getBooleanEvaluation('key', true);

    expect(eval.value, true);
  });
}
