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
      : this(targetingKey, ImmutableStructure(attributes));

  ImmutableContext.fromAttributes(Map<String, Value> attributes)
      : this('', ImmutableStructure(attributes));

  ImmutableContext.empty() : this('', ImmutableStructure({}));

  @override
  String getTargetingKey() => _targetingKey;

  @override
  EvaluationContext merge(EvaluationContext? overridingContext) {
    final newContext = overridingContext ??
        ImmutableContext.from(getTargetingKey(), asValueMap());
    var newTargetingKey = '';
    final targetKey = getTargetingKey();
    if (!(targetKey.trim() == '')) {
      newTargetingKey = targetKey;
    }

    final overridingTargetKey = newContext.getTargetingKey();
    if (!(overridingTargetKey.trim() == '')) {
      newTargetingKey = overridingTargetKey;
    }

    final merged = mergeStructures(
      (attributes) => ImmutableStructure(attributes),
      asValueMap(),
      newContext.asValueMap(),
    );

    return ImmutableContext.from(newTargetingKey, merged);
  }
}
