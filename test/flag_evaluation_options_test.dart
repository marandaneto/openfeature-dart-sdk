import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  test('empty options is empty', () {
    final options = FlagEvaluationOptions.empty();

    expect(options.hooks.isEmpty, true);
    expect(options.hookHints.isEmpty, true);
  });

  test('options get hooks', () {
    final options = FlagEvaluationOptions.fromHooks([FakeStringHook({})]);

    expect(options.hooks.length, 1);
  });

  test('options get hooks and hints', () {
    final hooks = [FakeStringHook({})];
    final options = FlagEvaluationOptions.from(hooks, {'key': 'value'});

    expect(options.hooks.length, 1);
    expect(options.hookHints.length, 1);
  });
}
