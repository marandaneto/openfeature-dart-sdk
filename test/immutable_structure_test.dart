import 'package:openfeature_dart/openfeature.dart';
import 'package:test/test.dart';

void main() {
  const key = 'key';
  const keyValue = 'value';

  test('no org should contain empty attributes', () {
    final structure = ImmutableStructure.empty();

    expect(structure.asValueMap.isEmpty, true);
  });

  test('map arg should contain new map', () {
    final map = {
      key: Value.fromObject(keyValue),
    };
    final structure = ImmutableStructure.fromAttributes(map);

    expect(structure.asValueMap[key]?.asString, keyValue);
    expect(identical(structure.asValueMap, map), false);
  });

  test('mutating get value should not change original value', () {
    final list = [Value.fromObject(keyValue)];
    final map = {
      key: Value.fromObject(list),
    };
    final structure = ImmutableStructure.fromAttributes(map);
    final values = structure.getValue(key)!.asValueList!;

    values.add(Value.fromObject('value2'));
    list.add(Value.fromObject('value3'));

    expect(structure.getValue(key)?.asValueList?.length, 1);
    expect(identical(structure.asValueMap, map), false);
  });

  test(
      'modifying the values returned by the keySet should not modify original value',
      () {
    final map = {
      key: Value.fromObject(keyValue),
      'key2': Value.fromObject('value2'),
    };
    final structure = ImmutableStructure.fromAttributes(map);

    final keys = structure.keySet;
    expect(() => keys.remove(key), throwsA(isA<UnsupportedError>()));

    expect(structure.keySet.length, 2);
    expect(structure.getValue(key)?.asString, keyValue);
  });

  test('getting a missing value should return null', () {
    final structure = ImmutableStructure.empty();

    expect(structure.getValue('missing'), isNull);
  });
}
