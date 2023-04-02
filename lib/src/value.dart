import 'immutable_structure.dart';
import 'structure.dart';

/// Values serve as a generic return type for structure data from providers.
/// Providers may deal in JSON, protobuf, XML or some other data-interchange format.
/// This intermediate representation provides a good medium of exchange.
class Value {
  final Object _innerObject;

  // TODO: throw InstantiationException equivalent if invalid type

  Value(this._innerObject);

  Value.fromValue(Value value) : _innerObject = value._innerObject;

  Value.fromBoolean(bool value) : _innerObject = value;

  Value.fromString(String value) : _innerObject = value;

  Value.fromInteger(int value) : _innerObject = value;

  Value.fromDouble(double value) : _innerObject = value;

  Value.fromStructure(Structure value) : _innerObject = value;

  Value.fromValueList(List<Value> value) : _innerObject = value;

  // Add Instant?

  bool get isBoolean => _innerObject is bool;

  bool get isString => _innerObject is String;

  bool get isNumber => _innerObject is num;

  bool get isStructure => _innerObject is Structure;

  bool get isValueList => _innerObject is List<Value>;

  // copyWith(Object object) => Value(object);

  bool? asBoolean() {
    if (isBoolean) {
      return _innerObject as bool;
    }
    return null;
  }

  String? asString() {
    if (isString) {
      return _innerObject as String;
    }
    return null;
  }

  int? asInteger() {
    if (isNumber) {
      return (_innerObject as num).toInt();
    }
    return null;
  }

  double? asDouble() {
    if (isNumber) {
      return (_innerObject as num).toDouble();
    }
    return null;
  }

  Structure? asStructure() {
    if (isStructure) {
      return _innerObject as Structure;
    }
    return null;
  }

  List<Value>? asValueList() {
    if (isValueList) {
      return _innerObject as List<Value>;
    }
    return null;
  }

  Object asObject() => _innerObject;

  Value clone() {
    if (isValueList) {
      final copy = asValueList()!.map((e) => Value(e)).toList();
      return Value.fromValueList(copy);
    }

    if (isStructure) {
      final copy = asStructure()
          !.asValueMap()
          .map((key, value) => MapEntry(key, Value(value.clone())));
      return Value.fromStructure(ImmutableStructure(copy));
    }

    return Value(asObject());
  }
}
