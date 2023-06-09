import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  test('no arg should contain null', () {
    expect(Value.empty().isNull, true);

    expect(Value.fromObject(null).isNull, true);
  });

  test('invalid arg should throw', () {
    expect(
        () => Value.fromObject(FakeNonValue()), throwsA(isA<ArgumentError>()));
  });

  test('invalid list arg should throw', () {
    expect(() => Value.fromObject([1, 'a']), throwsA(isA<ArgumentError>()));
  });

  test('object arg should contain object', () {
    final list = [
      true,
      'val',
      .5,
      ImmutableStructure.empty(),
      List<Value>.empty(),
      DateTime.now(),
    ];

    for (final item in list) {
      final value = Value.fromObject(item);
      expect(value.asObject, item);
    }
  });

  test('int object should contain int', () {
    final value = Value.fromObject(1);

    expect(value.isNumber, true);
    expect(value.asNum, 1);
  });

  test('double object should contain double', () {
    final value = Value.fromObject(1.0);

    expect(value.isNumber, true);
    expect(value.asNum, 1.0);
  });

  test('boolean object should contain boolean', () {
    final value = Value.fromObject(true);

    expect(value.isBoolean, true);
    expect(value.asBoolean, true);
  });

  test('string object should contain string', () {
    final value = Value.fromObject('test');

    expect(value.isString, true);
    expect(value.asString, 'test');
  });

  test('structure object should contain structure', () {
    final attributes = {'test': Value.fromObject('value')};
    final structure = ImmutableStructure.fromAttributes(attributes);
    final value = Value.fromObject(structure);

    expect(value.isStructure, true);
    expect(value.asStructure, structure);
    expect(value.asStructure?.getValue('test')?.asString, 'value');
  });

  test('value list object should contain value list', () {
    final list = [Value.fromObject('value')];
    final value = Value.fromObject(list);

    expect(value.isValueList, true);
    expect(value.asValueList, list);
    expect(value.asValueList?.first.asString, 'value');
  });

  test('datetime object should contain datetime', () {
    final dateTime = DateTime.now();
    final value = Value.fromObject(dateTime);

    expect(value.isDateTime, true);
    expect(value.asDateTime, dateTime);
  });
}
