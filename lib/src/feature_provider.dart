import 'dart:async';

import 'evaluation_context.dart';
import 'hook.dart';
import 'metadata.dart';
import 'provider_evaluation.dart';

/// The interface implemented by upstream flag providers to resolve flags for their service.
abstract class FeatureProvider {
  Metadata get metadata;

  List<Hook> get providerHooks => [];

  FutureOr<ProviderEvaluation<bool>> getBooleanEvaluation(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
  });
}
