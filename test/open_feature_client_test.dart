import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  final api = OpenFeatureAPI();

  setUp(() {
    api.reset();
  });

  test('meta data returns name and version', () {
    final client = api.getClient(
      'name',
      version: 'version',
    );

    expect(client.metadata.name, 'name');
    expect((client as OpenFeatureClient).version, 'version');
  });

  test('client adds hook', () {
    final client = api.getClient(
      'name',
      version: 'version',
    );
    client.addHook(FakeBooleanHook());

    expect(client.hooks.length, 1);
  });

  test('client returns default boolean with no op provider', () async {
    final client = api.getClient(
      'name',
      version: 'version',
    );
    final result = await client.getBooleanValue('key', true);

    expect(result, true);
  });

  test('client returns default string with no op provider', () async {
    final client = api.getClient(
      'name',
      version: 'version',
    );
    final result = await client.getStringValue('key', 'value');

    expect(result, 'value');
  });

  test('client returns default number with no op provider', () async {
    final client = api.getClient(
      'name',
      version: 'version',
    );
    final result = await client.getNumberValue('key', 1);

    expect(result, 1);
  });

  test('client returns default object with no op provider', () async {
    final client = api.getClient(
      'name',
      version: 'version',
    );
    final result = await client.getObjectValue('key', Value.fromObject(1));

    expect(result.asNum, 1);
  });
}
