import 'dart:async';
import 'dart:developer';

import 'client.dart';
import 'error_code.dart';
import 'evaluation_context.dart';
import 'exceptions/general_error.dart';
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
  final String? _version;
  final List<Hook> _clientHooks = [];
  EvaluationContext? _evaluationContext;
  final HookSupport _hookSupport = HookSupport();

  final MetadataName _metadata;

  OpenFeatureClient(
    this._openFeatureApi,
    String name, {
    String? version,
  })  : _version = version,
        _metadata = MetadataName(name);

  @override
  void addHook(Hook hook) => _clientHooks.add(hook);

  @override
  FutureOr<bool> getBooleanValue(
    String key, {
    bool defaultValue = false,
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) async {
    final result = await getBooleanDetails(
      key,
      defaultValue: defaultValue,
      evaluationContext: evaluationContext,
      options: options,
    );
    return result.value;
  }

  @override
  EvaluationContext? get evaluationContext => _evaluationContext;

  // make it immutable?
  @override
  List<Hook> get hooks => _clientHooks;

  @override
  Metadata get metadata => _metadata;

  @override
  set evaluationContext(EvaluationContext? evaluationContext) =>
      _evaluationContext = evaluationContext;

  @override
  FutureOr<FlagEvaluationDetails<bool>> getBooleanDetails(
    String key, {
    bool defaultValue = false,
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) async =>
      _evaluateFlag<bool>(
        FlagValueType.boolean,
        key,
        defaultValue,
        evaluationContext,
        options,
      );

  FutureOr<FlagEvaluationDetails<T>> _evaluateFlag<T>(
    FlagValueType type,
    String key,
    T defaultValue,
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  ) async {
    final context = evaluationContext ?? ImmutableContext.empty();
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

      ProviderEvaluation<T> providerEval = await _createProviderEvaluation<T>(
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
        errorMessage: e.toString(),
      );
    } finally {
      _hookSupport.afterAllHooks(
          type, hookCtx, mergedHooks, theOptions.hookHints);
    }

    return details;
  }

  FutureOr<ProviderEvaluation<T>> _createProviderEvaluation<T>(
    FlagValueType type,
    String key,
    T defaultValue,
    FeatureProvider provider,
    EvaluationContext evaluationContext,
  ) async {
    switch (type) {
      case FlagValueType.boolean:
        return await provider.getBooleanEvaluation(key, defaultValue as bool,
            evaluationContext: evaluationContext) as ProviderEvaluation<T>;
      default:
        // TODO: implement others
        throw GeneralError('Unknown flag type');
    }
  }
}
