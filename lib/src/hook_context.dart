import 'evaluation_context.dart';
import 'flag_value_type.dart';
import 'metadata.dart';

/// A data class to hold immutable context that [Hook] instances use.
class HookContext<T> {
  final String _flagKey;
  final FlagValueType _type;
  final T _defaultValue;
  final EvaluationContext _evaluationContext;
  final Metadata _clientMetadata;
  final Metadata _providerMetadata;

  HookContext._(
    this._flagKey,
    this._type,
    this._defaultValue,
    this._evaluationContext,
    this._clientMetadata,
    this._providerMetadata,
  );

  String get key => _flagKey;
  FlagValueType get type => _type;
  T get defaultValue => _defaultValue;
  Metadata get clientMetadata => _clientMetadata;
  Metadata get providerMetadata => _providerMetadata;
  EvaluationContext get evaluationContext => _evaluationContext;

  static HookContext<T> from<T>(
    String key,
    FlagValueType type,
    Metadata clientMetadata,
    Metadata providerMetadata,
    EvaluationContext evaluationContext,
    T defaultValue,
  ) =>
      HookContext<T>._(
        key,
        type,
        defaultValue,
        evaluationContext,
        clientMetadata,
        providerMetadata,
      );
}
