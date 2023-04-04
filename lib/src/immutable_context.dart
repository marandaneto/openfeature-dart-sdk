import 'package:meta/meta.dart';

import 'evaluation_context.dart';
import 'immutable_structure.dart';
import 'structure.dart';
import 'value.dart';

/// The EvaluationContext is a container for arbitrary contextual data that can be used as a basis for dynamic evaluation.
/// The ImmutableContext is an EvaluationContext implementation which is threadsafe, and whose attributes can not be modified after instantiation.
@sealed
class ImmutableContext extends EvaluationContext {
  final String _targetingKey;
  final Structure _structure;

  ImmutableContext(this._targetingKey, this._structure);

  ImmutableContext.from(String targetingKey, Map<String, Value> attributes)
      : this(targetingKey, ImmutableStructure.fromAttributes(attributes));

  ImmutableContext.fromAttributes(Map<String, Value> attributes)
      : this('', ImmutableStructure.fromAttributes(attributes));

  ImmutableContext.fromTargetingKey(String targetingKey)
      : this(targetingKey, ImmutableStructure.empty());

  ImmutableContext.empty() : this('', ImmutableStructure.empty());

  @override
  String get targetingKey => _targetingKey;

  @override
  EvaluationContext merge(EvaluationContext? overridingContext) {
    final newContext = overridingContext ??
        ImmutableContext.from(targetingKey, asValueMap);
    var newTargetingKey = '';
    final targetKey = targetingKey;
    if (!(targetKey.trim() == '')) {
      newTargetingKey = targetKey;
    }

    final overridingTargetKey = newContext.targetingKey;
    if (!(overridingTargetKey.trim() == '')) {
      newTargetingKey = overridingTargetKey;
    }

    final merged = mergeStructures(
      (attributes) => ImmutableStructure.fromAttributes(attributes),
      asValueMap,
      newContext.asValueMap,
    );

    return ImmutableContext.from(newTargetingKey, merged);
  }

  @override
  Map<String, Object> get asObjectMap => _structure.asObjectMap;

  @override
  Map<String, Value> get asValueMap => _structure.asValueMap;

  @override
  Value? getValue(String key) => _structure.getValue(key);

  @override
  Set<String> get keySet => _structure.keySet;
}
