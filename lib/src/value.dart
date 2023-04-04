import 'immutable_structure.dart';
import 'structure.dart';

/// Values serve as a generic return type for structure data from providers.
/// Providers may deal in JSON, protobuf, XML or some other data-interchange format.
/// This intermediate representation provides a good medium of exchange.
class Value {
  final Object? _innerObject;

  Value._(this._innerObject);

  Value.empty() : _innerObject = null;

  Value.fromValue(Value value) : _innerObject = value._innerObject;

  Value.fromBoolean(bool value) : _innerObject = value;

  Value.fromString(String value) : _innerObject = value;

  Value.fromInteger(int value) : _innerObject = value;

  Value.fromDouble(double value) : _innerObject = value;

  Value.fromStructure(Structure value) : _innerObject = value;

  Value.fromValueList(List<Value> value) : _innerObject = value;

  /// can throw [ArgumentError] if the type is not supported.
  Value.fromObject(Object? value) : _innerObject = value {
    if (!isBoolean &&
        !isString &&
        !isNumber &&
        !isStructure &&
        !isValueList &&
        !isNull) {
      throw ArgumentError('Invalid value type: $value');
    }
  }

  // Add Instant?

  bool get isBoolean => _innerObject is bool;

  bool get isString => _innerObject is String;

  bool get isNumber => _innerObject is num;

  bool get isStructure => _innerObject is Structure;

  bool get isValueList => _innerObject is List<Value>;

  bool get isNull => _innerObject == null;

  bool? get asBoolean {
    if (isBoolean) {
      return _innerObject as bool;
    }
    return null;
  }

  String? get asString {
    if (isString) {
      return _innerObject as String;
    }
    return null;
  }

  int? get asInteger {
    if (isNumber) {
      return (_innerObject as num).toInt();
    }
    return null;
  }

  double? get asDouble {
    if (isNumber) {
      return (_innerObject as num).toDouble();
    }
    return null;
  }

  Structure? get asStructure {
    if (isStructure) {
      return _innerObject as Structure;
    }
    return null;
  }

  List<Value>? get asValueList {
    if (isValueList) {
      return _innerObject as List<Value>;
    }
    return null;
  }

  Object? get asObject => _innerObject;

  Value clone() {
    if (isValueList) {
      final copy = asValueList!.map((e) => Value._(e)).toList();
      return Value.fromValueList(copy);
    }

    if (isStructure) {
      final copy = asStructure!.asValueMap
          .map((key, value) => MapEntry(key, Value._(value.clone())));
      return Value.fromStructure(ImmutableStructure.fromAttributes(copy));
    }

    return Value._(asObject);
  }
}
