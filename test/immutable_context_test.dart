import 'package:collection/collection.dart';
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

    expect(identical(ctx.asValueMap, map), false);
  });

  test('should change targeting key from overriding context', () {
    final map = {
      key: Value.fromObject(keyValue),
    };
    final ctx = ImmutableContext.from(key, map);
    final overridingCtx = ImmutableContext.fromTargetingKey('overridingKey');

    final merged = ctx.merge(overridingCtx);

    expect(merged.targetingKey, 'overridingKey');
  });

  test('target key should not change from overriding context if missing', () {
    final map = {
      key: Value.fromObject(keyValue),
    };
    final ctx = ImmutableContext.from(key, map);
    final overridingCtx = ImmutableContext.empty();

    final merged = ctx.merge(overridingCtx);

    expect(merged.targetingKey, key);
  });

  test(
      'merge should retain all the attributes from existing context when overriding context is null',
      () {
    final map = {
      key: Value.fromObject(keyValue),
    };
    final ctx = ImmutableContext.from(key, map);

    final merged = ctx.merge(null);

    expect(merged.targetingKey, key);
    expect(merged.keySet.length, 1);
    expect(merged.getValue(key)?.asString, keyValue);
  });

  test(
      'merge should retain retain subkeys from existing context when the overriding context has the same targeting key',
      () {
    final key1Attributes = {
      'key1_1': Value.fromObject('val1_1'),
    };
    final attributes = {
      'key1': Value.fromStructure(
          ImmutableStructure.fromAttributes(key1Attributes)),
      'key2': Value.fromObject('val2'),
    };
    final ovKey1Attributes = {
      'overriding_key1_1': Value.fromObject('overriding_val_1_1'),
    };
    final overridingAttributes = {
      'key1': Value.fromStructure(
        ImmutableStructure.fromAttributes(ovKey1Attributes),
      )
    };

    final ctx = ImmutableContext.from('targeting_key', attributes);
    final overridingCtx =
        ImmutableContext.from('targeting_key', overridingAttributes);
    final merged = ctx.merge(overridingCtx);

    expect(merged.targetingKey, 'targeting_key');
    // list is reversed, is that a bug?
    expect(
        ListEquality().equals(merged.keySet.toList(), ['key2', 'key1']), true);

    final key1 = merged.getValue('key1');
    expect(key1?.isStructure, true);

    final value = key1?.asStructure;
    expect(
        ListEquality()
            .equals(value?.keySet.toList(), ['overriding_key1_1', 'key1_1']),
        true);
  });

  test(
      'merge should retain retain subkeys from existing context when the overriding context does not have the targeting key',
      () {
    final key1Attributes = {
      'key1_1': Value.fromObject('val1_1'),
    };
    final attributes = {
      'key1': Value.fromStructure(
          ImmutableStructure.fromAttributes(key1Attributes)),
      'key2': Value.fromObject('val2'),
    };

    final ctx = ImmutableContext.from('targeting_key', attributes);
    final overridingCtx = ImmutableContext.empty();
    final merged = ctx.merge(overridingCtx);

    expect(
        ListEquality().equals(merged.keySet.toList(), ['key2', 'key1']), true);

    final key1 = merged.getValue('key1');
    expect(key1?.isStructure, true);

    final value = key1?.asStructure;
    expect(ListEquality().equals(value?.keySet.toList(), ['key1_1']), true);
  });
}
