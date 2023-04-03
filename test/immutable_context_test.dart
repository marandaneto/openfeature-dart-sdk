import 'package:openfeature_dart/openfeature.dart';
import 'package:test/test.dart';

void main() {
  const key = 'key';
  const keyValue = 'value';

  test('should create copy of attributes', () {
    final map = {
      key: Value.fromObject(keyValue),
    };
    final ctx = ImmutableContext.fromAttributes(map);
    map['key2'] = Value.fromObject('value2');

    expect(identical(ctx.asValueMap(), map), false);
  });

  test('should change targeting key from overriding context', () {
    final map = {
      key: Value.fromObject(keyValue),
    };
    final ctx = ImmutableContext.from(key, map);
    final overridingCtx = ImmutableContext.fromTargetingKey('overridingKey');

    final merged = ctx.merge(overridingCtx);

    expect(merged.getTargetingKey(), 'overridingKey');
  });

  test('target key should not change from overriding context if missing', () {
    final map = {
      key: Value.fromObject(keyValue),
    };
    final ctx = ImmutableContext.from(key, map);
    final overridingCtx = ImmutableContext.empty();

    final merged = ctx.merge(overridingCtx);

    expect(merged.getTargetingKey(), key);
  });

  test(
      'merge should retain all the attributes from existing context when overriding context is null',
      () {
    final map = {
      key: Value.fromObject(keyValue),
    };
    final ctx = ImmutableContext.from(key, map);

    final merged = ctx.merge(null);

    expect(merged.getTargetingKey(), key);
    expect(merged.keySet().length, 1);
    expect(merged.getValue(key)?.asString(), keyValue);
  });

  test(
      'merge should retain retain subkeys from existing context when the overriding context has the same targeting key',
      () {});
}
