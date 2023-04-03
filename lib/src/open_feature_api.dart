import 'evaluation_context.dart';
import 'feature_provider.dart';
import 'hook.dart';
import 'metadata.dart';

/// A global singleton which holds base configuration for the OpenFeature library.
/// Configuration here will be shared across all [Client].
class OpenFeatureAPI {
  final List<Hook> _apiHooks = [];

  FeatureProvider? _provider;

  EvaluationContext? _evaluationContext;

  OpenFeatureAPI._();

  static final OpenFeatureAPI _instance = OpenFeatureAPI._();

  factory OpenFeatureAPI() => _instance;

  Metadata? getProviderMetadata() => _provider?.getMetadata();

  FeatureProvider? getProvider() => _provider;

  List<Hook> get hooks => List.unmodifiable(_apiHooks);

  EvaluationContext? getEvaluationContext() => _evaluationContext;
}
