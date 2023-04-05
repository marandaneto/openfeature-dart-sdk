import 'dart:collection';

import 'package:meta/meta.dart';

import 'exceptions/value_not_convertable_error.dart';
import 'value.dart';

typedef StructureMergeFunction = Structure Function(
    Map<String, Value> parameters);

/// [Structure] represents a potentially nested object type which is used to represent structured data.
abstract class Structure {
  Set<String> get keySet;

  Value? getValue(String key);

  Map<String, Value> get asValueMap;

  Map<String, Object> get asObjectMap;

  /// can throw [ValueNotConvertableError] if the type is not supported.
  Object? convertValue(Value value) {
    if (value.isBoolean) {
      return value.asBoolean;
    }

    if (value.isNumber) {
      return value.asNum;
    }

    if (value.isString) {
      return value.asString;
    }

    if (value.isValueList) {
      return value.asValueList?.map((e) => convertValue(e)).toList();
    }

    if (value.isStructure) {
      final structure = value.asStructure;
      return structure?.asValueMap.map((key, value) {
        return MapEntry(key, convertValue(structure.getValue(key)!));
      });
    }

    if (value.isDateTime) {
      return value.asDateTime;
    }

    throw ValueNotConvertableError(
        '${value.asObject} is not convertable to a known type.');
  }

  @internal
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
        final mergedValue = merged[key]!.asStructure!;
        final overridingValue = value.asStructure!;
        final newMap = mergeStructures(
            newStructure, mergedValue.asValueMap, overridingValue.asValueMap);
        merged[key] = Value.fromStructure(newStructure(newMap));
      } else {
        merged[key] = value;
      }
    }

    return merged;
  }
}
