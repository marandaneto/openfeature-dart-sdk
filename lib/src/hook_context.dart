import 'evaluation_context.dart';
import 'flag_value_type.dart';
import 'metadata.dart';

/// A data class to hold immutable context that [Hook] instances use.
class HookContext<T> {
  final String _flagKey;
  final FlagValueType _type;
  final T _defaultValue;
  final EvaluationContext ctx;
  final Metadata _clientMetadata;
  final Metadata _providerMetadata;

  HookContext._(
    this._flagKey,
    this._type,
    this._defaultValue,
    this.ctx,
    this._clientMetadata,
    this._providerMetadata,
  );

  static HookContext<T> from<T>(
    String key,
    FlagValueType type,
    Metadata clientMetadata,
    Metadata providerMetadata,
    EvaluationContext ctx,
    T defaultValue,
  ) =>
      HookContext<T>._(
        key,
        type,
        defaultValue,
        ctx,
        clientMetadata,
        providerMetadata,
      );
}
