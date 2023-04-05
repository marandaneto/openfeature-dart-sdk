import '../evaluation_context.dart';
import '../feature_provider.dart';
import '../metadata.dart';
import '../metadata_name.dart';
import '../provider_evaluation.dart';
import '../reason.dart';
import '../value.dart';

/// A [FeatureProvider] that simply returns the default values passed to it.
class NoOpProvider extends FeatureProvider {
  static const String _defaultVariant = "Passed in default";
  static const String _name = "No-op Provider";

  final _metadata = MetadataName(_name);

  @override
  Metadata get metadata => _metadata;

  @override
  ProviderEvaluation<bool> getBooleanEvaluation(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      ProviderEvaluation<bool>(
        defaultValue,
        Reason.defaultReason,
        variant: _defaultVariant,
      );

  @override
  ProviderEvaluation<num> getNumberEvaluation(
    String key,
    num defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      ProviderEvaluation<num>(
        defaultValue,
        Reason.defaultReason,
        variant: _defaultVariant,
      );

  @override
  ProviderEvaluation<Value> getObjectEvaluation(
    String key,
    Value defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      ProviderEvaluation<Value>(
        defaultValue,
        Reason.defaultReason,
        variant: _defaultVariant,
      );

  @override
  ProviderEvaluation<String> getStringEvaluation(
    String key,
    String defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      ProviderEvaluation<String>(
        defaultValue,
        Reason.defaultReason,
        variant: _defaultVariant,
      );
}
