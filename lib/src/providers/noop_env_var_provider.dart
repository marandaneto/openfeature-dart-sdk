import '../evaluation_context.dart';
import '../feature_provider.dart';
import '../metadata.dart';
import '../provider_evaluation.dart';
import '../value.dart';
import 'no_op_provider.dart';

/// [NoOpProvider] version of [EnvVarProvider] since Web does not have dart:io.
class EnvVarProvider extends FeatureProvider {
  final _noOpProvider = NoOpProvider();

  @override
  ProviderEvaluation<bool> getBooleanEvaluation(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      _noOpProvider.getBooleanEvaluation(
        key,
        defaultValue,
        evaluationContext: evaluationContext,
      );

  @override
  Metadata get metadata => _noOpProvider.metadata;

  @override
  ProviderEvaluation<num> getNumberEvaluation(
    String key,
    num defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      _noOpProvider.getNumberEvaluation(
        key,
        defaultValue,
        evaluationContext: evaluationContext,
      );

  @override
  ProviderEvaluation<Value> getObjectEvaluation(
    String key,
    Value defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      _noOpProvider.getObjectEvaluation(
        key,
        defaultValue,
        evaluationContext: evaluationContext,
      );

  @override
  ProviderEvaluation<String> getStringEvaluation(
    String key,
    String defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      _noOpProvider.getStringEvaluation(
        key,
        defaultValue,
        evaluationContext: evaluationContext,
      );
}
