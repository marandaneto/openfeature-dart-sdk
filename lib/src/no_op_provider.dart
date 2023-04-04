import 'evaluation_context.dart';
import 'feature_provider.dart';
import 'metadata.dart';
import 'metadata_name.dart';
import 'provider_evaluation.dart';
import 'reason.dart';

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
        _defaultVariant,
        Reason.defaultReason,
      );
}
