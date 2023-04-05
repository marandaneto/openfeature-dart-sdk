import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  final api = OpenFeatureAPI();

  setUp(() {
    api.reset();
  });

  test('api adds hook', () {
    api.addHook(FakeBooleanHook());

    expect(api.hooks.length, 1);
  });

  test('api cleans hooks', () {
    api.addHook(FakeBooleanHook());

    expect(api.hooks.length, 1);
    api.clearHooks();

    expect(api.hooks.length, 0);
  });

  test('api sets provider and return its name', () {
    api.provider = NoOpProvider();

    expect(api.providerMetadata?.name, 'No-op Provider');
  });

  test('api creates $OpenFeatureClient', () {
    final client = api.getClient('name', version: 'version');

    expect(client is OpenFeatureClient, true);
  });
}
