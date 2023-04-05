import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  test('boolean hook returns true', () {
    final hook = FakeBooleanHook();

    expect(hook.supportsFlagValueType(FlagValueType.boolean), true);
  });

  test('boolean hook returns false', () {
    final hook = FakeBooleanHook();

    expect(hook.supportsFlagValueType(FlagValueType.string), false);
  });
}
