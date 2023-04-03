import 'client.dart';
import 'evaluation_context.dart';
import 'feature_provider.dart';
import 'hook.dart';
import 'metadata.dart';
import 'open_feature_client.dart';

/// A global singleton which holds base configuration for the OpenFeature library.
/// Configuration here will be shared across all [Client].
class OpenFeatureAPI {
  final List<Hook> _apiHooks = [];

  FeatureProvider? provider;

  EvaluationContext? _evaluationContext;

  OpenFeatureAPI._();

  static final OpenFeatureAPI _instance = OpenFeatureAPI._();

  factory OpenFeatureAPI() => _instance;

  Metadata? getProviderMetadata() => provider?.getMetadata();

  List<Hook> get hooks => List.unmodifiable(_apiHooks);

  EvaluationContext? getEvaluationContext() => _evaluationContext;

  Client getClient({
    String? name,
    String? version,
  }) =>
      OpenFeatureClient(this, name: name, version: version);
}
