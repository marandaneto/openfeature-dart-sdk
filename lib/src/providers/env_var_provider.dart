import 'dart:io';

import '../evaluation_context.dart';
import '../exceptions/parse_error.dart';
import '../feature_provider.dart';
import '../metadata.dart';
import '../metadata_name.dart';
import '../provider_evaluation.dart';
import '../reason.dart';
import '../value.dart';

typedef ParseFunction<T> = T Function(String);

class EnvVarProvider extends FeatureProvider {
  static const _name = 'Environment Variables Provider';
  static const String _defaultVariant = "Passed in default";

  final Metadata _metadata = MetadataName(_name);

  @override
  ProviderEvaluation<bool> getBooleanEvaluation(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      _evaluateEnvironmentVariable<bool>(
          key, defaultValue, (value) => _parseBool(value));

  @override
  Metadata get metadata => _metadata;

  /// can throw [ParseError] if the value is not a valid boolean.
  ProviderEvaluation<T> _evaluateEnvironmentVariable<T>(
    String key,
    T defaultValue,
    ParseFunction parser,
  ) {
    final env = Platform.environment[key];

    if (env == null) {
      // returns default value if the environment variable is not set.
      return ProviderEvaluation<T>(
        defaultValue,
        Reason.static,
        variant: _defaultVariant,
      );
    }

    try {
      return ProviderEvaluation<T>(
        parser(env),
        Reason.static,
      );
    } catch (error) {
      throw ParseError('$env cannot be parsed as a $T.');
    }
  }

  bool _parseBool(String value) {
    if (value == 'true') {
      return true;
    } else if (value == 'false') {
      return false;
    } else {
      throw FormatException('$value cannot be parsed as a boolean.');
    }
  }

  @override
  ProviderEvaluation<num> getNumberEvaluation(
    String key,
    num defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      _evaluateEnvironmentVariable<num>(
          key, defaultValue, (value) => num.parse(value));

  @override
  ProviderEvaluation<Value> getObjectEvaluation(
    String key,
    Value defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      _evaluateEnvironmentVariable<Value>(
          key, defaultValue, (value) => Value.fromObject(value));

  @override
  ProviderEvaluation<String> getStringEvaluation(
    String key,
    String defaultValue, {
    EvaluationContext? evaluationContext,
  }) =>
      _evaluateEnvironmentVariable<String>(key, defaultValue, (value) => value);
}
