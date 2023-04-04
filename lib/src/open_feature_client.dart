import 'dart:developer';

import 'client.dart';
import 'error_code.dart';
import 'evaluation_context.dart';
import 'feature_provider.dart';
import 'flag_evaluation_details.dart';
import 'flag_evaluation_options.dart';
import 'flag_value_type.dart';
import 'hook.dart';
import 'hook_context.dart';
import 'hook_support.dart';
import 'immutable_context.dart';
import 'metadata.dart';
import 'metadata_name.dart';
import 'no_op_provider.dart';
import 'open_feature_api.dart';
import 'provider_evaluation.dart';
import 'reason.dart';

class OpenFeatureClient implements Client {
  final OpenFeatureAPI _openFeatureApi;
  final String _name;
  final String? _version;
  final List<Hook> _clientHooks = [];
  EvaluationContext? _evaluationContext;
  final HookSupport _hookSupport = HookSupport();

  OpenFeatureClient(
    this._openFeatureApi,
    this._name, {
    String? name,
    String? version,
  }) : _version = version;

  @override
  void addHook(Hook hook) => _clientHooks.add(hook);

  @override
  bool getBooleanValue(
    String key, {
    bool defaultValue = false,
    EvaluationContext? ctx,
    FlagEvaluationOptions? options,
  }) =>
      getBooleanDetails(
        key,
        defaultValue: defaultValue,
        ctx: ctx,
        options: options,
      ).value;

  @override
  EvaluationContext? get evaluationContext => _evaluationContext;

  // make it immutable?
  @override
  List<Hook> get hooks => _clientHooks;

  @override
  Metadata get metadata => MetadataName(_name);

  @override
  set evaluationContext(EvaluationContext? ctx) => _evaluationContext = ctx;

  @override
  FlagEvaluationDetails<bool> getBooleanDetails(
    String key, {
    bool defaultValue = false,
    EvaluationContext? ctx,
    FlagEvaluationOptions? options,
  }) =>
      _evaluateFlag<bool>(
        FlagValueType.boolean,
        key,
        defaultValue,
        ctx,
        options,
      );

  FlagEvaluationDetails<T> _evaluateFlag<T>(
    FlagValueType type,
    String key,
    T defaultValue,
    EvaluationContext? ctx,
    FlagEvaluationOptions? options,
  ) {
    final context = ctx ?? ImmutableContext.empty();
    final theOptions = options ?? FlagEvaluationOptions.empty();
    FlagEvaluationDetails<T>? details;
    final provider = _openFeatureApi.provider ?? NoOpProvider();
    final hookCtx = HookContext.from<T>(
      key,
      type,
      metadata,
      provider.metadata,
      context,
      defaultValue,
    );
    final mergedHooks = [
      ...provider.providerHooks,
      ...theOptions.hooks,
      ..._clientHooks,
      ..._openFeatureApi.hooks,
    ];

    try {
      final apiContext =
          _openFeatureApi.evaluationContext ?? ImmutableContext.empty();

      final clientContext = evaluationContext ?? ImmutableContext.empty();

      final ctxFromHook = _hookSupport.beforeHooks(
          type, hookCtx, mergedHooks, theOptions.hookHints);

      final invocationCtx = context.merge(ctxFromHook);

      final mergedCtx = apiContext.merge(clientContext.merge(invocationCtx));

      ProviderEvaluation<T> providerEval = _createProviderEvaluation<T>(
          type, key, defaultValue, provider, mergedCtx);

      details = FlagEvaluationDetails.from<T>(providerEval, key);
      _hookSupport.afterHooks(
          type, hookCtx, details, mergedHooks, theOptions.hookHints);
    } catch (e, stackTrace) {
      log(
        "Error evaluating flag $key",
        error: e,
        stackTrace: stackTrace,
        name: 'openfeature',
      );

      // TODO: treat errors

      _hookSupport.errorHooks(
          type, hookCtx, e, mergedHooks, theOptions.hookHints);

      details = FlagEvaluationDetails<T>(
        key,
        defaultValue,
        // variant: '',
        reason: Reason.error,
        errorCode: ErrorCode.general,
        // errorMessage: '',
      );
    } finally {
      _hookSupport.afterAllHooks(
          type, hookCtx, mergedHooks, theOptions.hookHints);
    }

    return details;
  }

  ProviderEvaluation<T> _createProviderEvaluation<T>(
    FlagValueType type,
    String key,
    T defaultValue,
    FeatureProvider provider,
    EvaluationContext invocationContext,
  ) {
    switch (type) {
      case FlagValueType.boolean:
        return provider.getBooleanEvaluation(key, defaultValue as bool,
            ctx: invocationContext) as ProviderEvaluation<T>;
      default:
        // TODO: implement others
        throw UnimplementedError();
    }
  }
}
