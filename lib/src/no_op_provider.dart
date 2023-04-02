import 'evaluation_context.dart';
import 'feature_provider.dart';
import 'metadata.dart';
import 'provider_evaluation.dart';
import 'reason.dart';

/// A [FeatureProvider] that simply returns the default values passed to it.
class NoOpProvider extends FeatureProvider {
  static const String _default = "Passed in default";

  @override
  Metadata getMetadata() => _Metadata();

  @override
  ProviderEvaluation<bool> getBooleanEvaluation(String key,
      {bool defaultValue = false, EvaluationContext? ctx}) {
    return ProviderEvaluation(
      defaultValue,
      _default,
      Reason.defaultReason,
      null,
      null,
    );
  }
}

class _Metadata implements Metadata {
  static const String _name = "No-op Provider";

  @override
  String getName() => _name;
}
