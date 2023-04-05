import 'dart:async';

import 'evaluation_context.dart';
import 'hook.dart';
import 'metadata.dart';
import 'provider_evaluation.dart';
import 'value.dart';

/// The interface implemented by upstream flag providers to resolve flags for their service.
abstract class FeatureProvider {
  Metadata get metadata;

  final List<Hook> _providerHooks = [];

  List<Hook> get providerHooks => List.unmodifiable(_providerHooks);

  FutureOr<ProviderEvaluation<bool>> getBooleanEvaluation(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
  });

  FutureOr<ProviderEvaluation<String>> getStringEvaluation(
    String key,
    String defaultValue, {
    EvaluationContext? evaluationContext,
  });

  FutureOr<ProviderEvaluation<num>> getNumberEvaluation(
    String key,
    num defaultValue, {
    EvaluationContext? evaluationContext,
  });

  FutureOr<ProviderEvaluation<Value>> getObjectEvaluation(
    String key,
    Value defaultValue, {
    EvaluationContext? evaluationContext,
  });

  addHook(Hook hook) => _providerHooks.add(hook);
}
