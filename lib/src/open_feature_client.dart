import 'client.dart';
import 'evaluation_context.dart';
import 'flag_evaluation_details.dart';
import 'flag_evaluation_options.dart';
import 'flag_value_type.dart';
import 'hook.dart';
import 'hook_context.dart';
import 'hook_support.dart';
import 'immutable_context.dart';
import 'metadata.dart';
import 'no_op_provider.dart';
import 'open_feature_api.dart';
import 'provider_evaluation.dart';
import 'reason.dart';

class OpenFeatureClient implements Client {
  final OpenFeatureAPI _openfeatureApi;
  final String _name;
  final String _version;
  final List<Hook> _clientHooks = [];
  EvaluationContext? _evaluationContext;
  final HookSupport _hookSupport = HookSupport();

  OpenFeatureClient(this._openfeatureApi, this._name, this._version);

  @override
  void addHook(Hook hook) => _clientHooks.add(hook);

  @override
  bool getBooleanValue(String key,
      {bool defaultValue = false, EvaluationContext? ctx}) {
    // TODO: implement getBooleanValue
    throw UnimplementedError();
  }

  @override
  EvaluationContext? getEvaluationContext() => _evaluationContext;

  // make it immutable?
  @override
  List<Hook> getHooks() => _clientHooks;

  @override
  Metadata getMetadata() => _Metadata(_name);

  @override
  void setEvaluationContext(EvaluationContext ctx) => _evaluationContext = ctx;

  @override
  FlagEvaluationDetails<bool> getBooleanDetails(String key,
      {bool defaultValue = false, EvaluationContext? ctx}) {
    // return eva

    throw UnimplementedError();
  }

  FlagEvaluationDetails<T> _evaluateFlag<T>(
    FlagValueType type,
    String key,
    T defaultValue,
    EvaluationContext? ctx,
    FlagEvaluationOptions options,
  ) {
    final context = ctx ?? ImmutableContext.empty();

    try {
      final provider = _openfeatureApi.getProvider() ?? NoOpProvider();

      final mergedHooks = [
        ...provider.getProviderHooks(),
        ...options.hooks,
        ..._clientHooks,
        ..._openfeatureApi.hooks,
      ];

      final hookCtx = HookContext.from(
        key,
        type,
        getMetadata(),
        provider.getMetadata(),
        context,
        defaultValue,
      );

      final apiContext =
          _openfeatureApi.getEvaluationContext() ?? ImmutableContext.empty();

      final clientContext = getEvaluationContext() ?? ImmutableContext.empty();

      // EvaluationContext ctxFromHook = _hookSupport.
    } catch (e, stackTrace) {
      // log it
    }

    return FlagEvaluationDetails.from(
        ProviderEvaluation(defaultValue, '', Reason.cached, null, null), key);
  }
}

class _Metadata implements Metadata {
  final String _name;

  _Metadata(this._name);

  @override
  String getName() => _name;
}
