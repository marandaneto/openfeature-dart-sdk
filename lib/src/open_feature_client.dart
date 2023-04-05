import 'dart:async';
import 'dart:developer';

import 'package:openfeature/src/value.dart';

import 'client.dart';
import 'error_code.dart';
import 'evaluation_context.dart';
import 'exceptions/general_error.dart';
import 'exceptions/open_feature_error.dart';
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
import 'providers/no_op_provider.dart';
import 'open_feature_api.dart';
import 'provider_evaluation.dart';
import 'reason.dart';

class OpenFeatureClient implements Client {
  final OpenFeatureAPI _openFeatureApi;
  final String? _version;
  final List<Hook> _clientHooks = [];

  @override
  EvaluationContext? evaluationContext;

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
  List<Hook> get hooks => List.unmodifiable(_clientHooks);

  @override
  Metadata get metadata => _metadata;

  String? get version => _version;

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

    if (provider is NoOpProvider) {
      log(
        'No provider configured, using no-op provider.',
        name: 'openfeature',
      );
    }

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

      final clientContext = this.evaluationContext ?? ImmutableContext.empty();

      final ctxFromHook = _hookSupport.beforeHooks(
          type, hookCtx, mergedHooks, theOptions.hookHints);

      final invocationCtx = context.merge(ctxFromHook);

      final mergedCtx = apiContext.merge(clientContext.merge(invocationCtx));

      ProviderEvaluation<T> providerEval = await _createProviderEvaluation<T>(
          type, key, defaultValue, provider, mergedCtx);

      details = FlagEvaluationDetails.from<T>(providerEval, key);
      _hookSupport.afterHooks(
          type, hookCtx, details, mergedHooks, theOptions.hookHints);
    } catch (error, stackTrace) {
      log(
        'Error evaluating flag $key',
        error: error,
        stackTrace: stackTrace,
        name: 'openfeature',
      );

      final errorCode =
          (error is OpenFeatureError) ? error.errorCode : ErrorCode.general;

      final eval = ProviderEvaluation<T>(
        defaultValue,
        Reason.error,
        errorCode: errorCode,
        errorMessage: error.toString(),
      );
      details = FlagEvaluationDetails.from<T>(eval, key);

      _hookSupport.errorHooks(
          type, hookCtx, error, mergedHooks, theOptions.hookHints);
    } finally {
      _hookSupport.afterAllHooks(
          type, hookCtx, mergedHooks, theOptions.hookHints);
    }

    return details;
  }

  /// can throw [GeneralError] if the type is not supported
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
      case FlagValueType.string:
        return await provider.getStringEvaluation(key, defaultValue as String,
            evaluationContext: evaluationContext) as ProviderEvaluation<T>;
      case FlagValueType.number:
        return await provider.getNumberEvaluation(key, defaultValue as num,
            evaluationContext: evaluationContext) as ProviderEvaluation<T>;
      case FlagValueType.object:
        return await provider.getObjectEvaluation(key, defaultValue as Value,
            evaluationContext: evaluationContext) as ProviderEvaluation<T>;
      default:
        throw GeneralError('Unknown flag type: $type.');
    }
  }

  @override
  FutureOr<bool> getBooleanValue(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) async {
    FutureOr<bool> wrapped() async {
      final result = await getBooleanDetails(
        key,
        defaultValue,
        evaluationContext: evaluationContext,
        options: options,
      );
      return result.value;
    }

    return wrapped();
  }

  @override
  FutureOr<FlagEvaluationDetails<bool>> getBooleanDetails(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) =>
      _evaluateFlag<bool>(
        FlagValueType.boolean,
        key,
        defaultValue,
        evaluationContext,
        options,
      );

  @override
  FutureOr<FlagEvaluationDetails<num>> getNumberDetails(
    String key,
    num defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) =>
      _evaluateFlag<num>(
        FlagValueType.number,
        key,
        defaultValue,
        evaluationContext,
        options,
      );

  @override
  FutureOr<num> getNumberValue(
    String key,
    num defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) async {
    FutureOr<num> wrapped() async {
      final result = await getNumberDetails(
        key,
        defaultValue,
        evaluationContext: evaluationContext,
        options: options,
      );
      return result.value;
    }

    return wrapped();
  }

  @override
  FutureOr<FlagEvaluationDetails<Value>> getObjectDetails(
    String key,
    Value defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) =>
      _evaluateFlag<Value>(
        FlagValueType.object,
        key,
        defaultValue,
        evaluationContext,
        options,
      );

  @override
  FutureOr<Value> getObjectValue(
    String key,
    Value defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) async {
    FutureOr<Value> wrapped() async {
      final result = await getObjectDetails(
        key,
        defaultValue,
        evaluationContext: evaluationContext,
        options: options,
      );
      return result.value;
    }

    return wrapped();
  }

  @override
  FutureOr<FlagEvaluationDetails<String>> getStringDetails(
    String key,
    String defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) =>
      _evaluateFlag<String>(
        FlagValueType.string,
        key,
        defaultValue,
        evaluationContext,
        options,
      );

  @override
  FutureOr<String> getStringValue(
    String key,
    String defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  }) async {
    FutureOr<String> wrapped() async {
      final result = await getStringDetails(
        key,
        defaultValue,
        evaluationContext: evaluationContext,
        options: options,
      );
      return result.value;
    }

    return wrapped();
  }
}
