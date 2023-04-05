import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

void main() {
  final attributes = {
    'key': Value.fromObject('keyValue'),
  };
  final baseCtx = ImmutableContext.fromAttributes(attributes);
  final hookCtx = HookContext.from<String>(
    'flagKey',
    FlagValueType.string,
    MetadataName('client'),
    MetadataName('provider'),
    baseCtx,
    'defaultValue',
  );

  test('context returns key', () {
    expect(hookCtx.key, 'flagKey');
  });

  test('context returns type', () {
    expect(hookCtx.type, FlagValueType.string);
  });

  test('context returns client metadata', () {
    expect(hookCtx.clientMetadata.name, 'client');
  });

  test('context returns provider metadata', () {
    expect(hookCtx.providerMetadata.name, 'provider');
  });

  test('context returns base context', () {
    expect(hookCtx.evaluationContext, baseCtx);
  });

  test('context returns default value', () {
    expect(hookCtx.defaultValue, 'defaultValue');
  });
}
