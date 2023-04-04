import 'dart:collection';

import 'package:meta/meta.dart';

import 'structure.dart';
import 'value.dart';

@sealed
class ImmutableStructure extends Structure {
  final Map<String, Value> _attributes;

  ImmutableStructure._(Map<String, Value> attributes)
      : _attributes = attributes;

  ImmutableStructure.fromAttributes(Map<String, Value> attributes)
      : this._(attributes.map((key, value) => MapEntry(key, value.clone())));

  ImmutableStructure.empty() : this._({});

  @override
  Map<String, Object> get asObjectMap => _attributes
      .map((key, value) => MapEntry(key, convertValue(getValue(key)!)!));

  @override
  Map<String, Value> get asValueMap =>
      _attributes.map((key, value) => MapEntry(key, getValue(key)!));

  @override
  Value? getValue(String key) => _attributes[key]?.clone();

  @override
  Set<String> get keySet => HashSet.from(_attributes.keys);
}
