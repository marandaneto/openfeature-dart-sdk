import 'package:collection/collection.dart';
import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

void main() {
  test('convert value to boolean', () {
    final value = Value.fromBoolean(true);
    final structure = ImmutableStructure.empty();

    expect(structure.convertValue(value), true);
  });

  test('convert value to string', () {
    final value = Value.fromString('test');
    final structure = ImmutableStructure.empty();

    expect(structure.convertValue(value), 'test');
  });

  test('convert value to number', () {
    final value = Value.fromNumber(1);
    final structure = ImmutableStructure.empty();

    expect(structure.convertValue(value), 1);
  });

  test('convert value to value list', () {
    final str = 'test';
    final values = [Value.fromString(str)];
    final value = Value.fromValueList(values);
    final structure = ImmutableStructure.empty();

    expect(
        DeepCollectionEquality().equals(structure.convertValue(value), [str]),
        true);
  });

  test('convert value to structure', () {
    final innerMap =
        ImmutableStructure.fromAttributes({'key': Value.fromNumber(1)});
    final value = Value.fromStructure(innerMap);

    final structure = ImmutableStructure.empty();

    expect(
        DeepCollectionEquality()
            .equals(structure.convertValue(value), {'key': 1}),
        true);
  });

  test('convert value to datetime', () {
    final now = DateTime.now();
    final value = Value.fromDateTime(now);
    final structure = ImmutableStructure.empty();

    expect(structure.convertValue(value), now);
  });
}
