import 'dart:collection';

import 'value.dart';

typedef StructureMergeFunction = Structure Function(
    Map<String, Value> parameters);

/// [Structure] represents a potentially nested object type which is used to represent structured data.
abstract class Structure {
  Set<String> keySet();

  Value? getValue(String key);

  Map<String, Value> asValueMap();

  Map<String, Object> asObjectMap();

  // TODO: throw instead of returning null
  Object? convertValue(Value value) {
    if (value.isBoolean) {
      return value.asBoolean();
    }

    if (value.isNumber) {
      final number = value.asObject();

      if (number is int) {
        return value.asInteger();
      } else if (number is double) {
        return value.asDouble();
      } else {
        return null;
      }
    }

    if (value.isString) {
      return value.asString();
    }

    if (value.isValueList) {
      return value.asValueList()?.map((e) => convertValue(e)).toList();
    }

    if (value.isStructure) {
      final structure = value.asStructure();
      return structure?.asValueMap().map((key, value) {
        return MapEntry(key, convertValue(structure.getValue(key)!));
      });
    }

    return null;
  }

  Map<String, Value> mergeStructures(
    StructureMergeFunction newStructure,
    Map<String, Value> base,
    Map<String, Value> overriding,
  ) {
    final merged = HashMap<String, Value>();

    merged.addAll(base);

    for (final overridingEntry in overriding.entries) {
      final key = overridingEntry.key;
      final value = overridingEntry.value;

      if (value.isStructure &&
          merged.containsKey(key) &&
          merged[key]!.isStructure) {
        final mergedValue = merged[key]!.asStructure()!;
        final overridingValue = value.asStructure()!;
        final newMap = mergeStructures(newStructure, mergedValue.asValueMap(),
            overridingValue.asValueMap());
        merged[key] = Value.fromStructure(newStructure(newMap));
      } else {
        merged[key] = value;
      }
    }

    return merged;
  }
}
