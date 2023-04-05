import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  test('feature provider adds hook', () {
    final feature = NoOpProvider();

    feature.addHook(FakeStringHook({}));

    expect(feature.providerHooks.length, 1);
  });
}
