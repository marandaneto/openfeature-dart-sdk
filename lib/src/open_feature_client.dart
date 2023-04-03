import 'dart:developer';

import 'package:openfeature_dart/src/error_code.dart';

import 'client.dart';
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
      ).getValue();

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
    final provider = _openfeatureApi.getProvider() ?? NoOpProvider();
    final hookCtx = HookContext.from<T>(
      key,
      type,
      getMetadata(),
      provider.getMetadata(),
      context,
      defaultValue,
    );
    final mergedHooks = [
      ...provider.getProviderHooks(),
      ...theOptions.hooks,
      ..._clientHooks,
      ..._openfeatureApi.hooks,
    ];

    try {
      final apiContext =
          _openfeatureApi.getEvaluationContext() ?? ImmutableContext.empty();

      final clientContext = getEvaluationContext() ?? ImmutableContext.empty();

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
          key, defaultValue, '', Reason.error, ErrorCode.general, '');
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
        return provider.getBooleanEvaluation(key,
            defaultValue: defaultValue as bool,
            ctx: invocationContext) as ProviderEvaluation<T>;
      default:
        // TODO: implement others
        throw UnimplementedError();
    }
  }
}

class _Metadata implements Metadata {
  final String _name;

  _Metadata(this._name);

  @override
  String getName() => _name;
}
