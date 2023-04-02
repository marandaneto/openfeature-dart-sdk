import 'evaluation_context.dart';
import 'hook.dart';
import 'metadata.dart';
import 'provider_evaluation.dart';

/// The interface implemented by upstream flag providers to resolve flags for their service.
abstract class FeatureProvider {
  Metadata getMetadata();

  List<Hook> getProviderHooks() => [];

  // TODO: EvaluationContext not optional?
  ProviderEvaluation<bool> getBooleanEvaluation(
    String key, {
    bool defaultValue,
    EvaluationContext? ctx,
  });
}
