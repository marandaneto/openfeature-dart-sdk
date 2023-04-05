import 'package:meta/meta.dart';

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

  EvaluationContext? evaluationContext;

  OpenFeatureAPI._();

  static final OpenFeatureAPI _instance = OpenFeatureAPI._();

  factory OpenFeatureAPI() => _instance;

  Metadata? get providerMetadata => provider?.metadata;

  List<Hook> get hooks => List.unmodifiable(_apiHooks);

  Client getClient(
    String name, {
    String? version,
  }) =>
      OpenFeatureClient(this, name, version: version);

  void clearHooks() => _apiHooks.clear();

  void addHook(Hook hook) => _apiHooks.add(hook);

  @visibleForTesting
  void reset() {
    clearHooks();
    evaluationContext = null;
    provider = null;
  }
}
