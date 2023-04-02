import 'dart:collection';

import 'package:meta/meta.dart';

import 'structure.dart';
import 'value.dart';

@sealed
class ImmutableStructure extends Structure {
  final Map<String, Value> _attributes;

  ImmutableStructure(Map<String, Value> attributes)
      : _attributes =
            attributes.map((key, value) => MapEntry(key, value.clone()));

  @override
  Map<String, Object> asObjectMap() => _attributes
      .map((key, value) => MapEntry(key, convertValue(getValue(key)!)!));

  @override
  Map<String, Value> asValueMap() =>
      _attributes.map((key, value) => MapEntry(key, getValue(key)!));

  @override
  Value? getValue(String key) => _attributes[key]?.clone();

  @override
  Set<String> keySet() => HashSet.from(_attributes.keys);
}
