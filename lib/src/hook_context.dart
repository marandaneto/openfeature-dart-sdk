import 'evaluation_context.dart';
import 'flag_value_type.dart';
import 'metadata.dart';

/// A data class to hold immutable context that [Hook] instances use.
class HookContext<T> {
  final String _flagKey;
  final FlagValueType _type;
  final T _defaultValue;
  final EvaluationContext _ctx;
  final Metadata _clientMetadata;
  final Metadata _providerMetadata;

  HookContext._(
    this._flagKey,
    this._type,
    this._defaultValue,
    this._ctx,
    this._clientMetadata,
    this._providerMetadata,
  );

  HookContext.from(
    String key,
    FlagValueType type,
    Metadata clientMetadata,
    Metadata providerMetadata,
    EvaluationContext ctx,
    T defaultValue,
  ) : this._(
          key,
          type,
          defaultValue,
          ctx,
          clientMetadata,
          providerMetadata,
        );
}
