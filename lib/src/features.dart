import 'dart:async';

import 'evaluation_context.dart';
import 'flag_evaluation_details.dart';
import 'flag_evaluation_options.dart';
import 'value.dart';

/// An API for the type-specific fetch methods offered to users.
abstract class Features {
  FutureOr<bool> getBooleanValue(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });

  FutureOr<FlagEvaluationDetails<bool>> getBooleanDetails(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });

  FutureOr<String> getStringValue(
    String key,
    String defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });

  FutureOr<FlagEvaluationDetails<String>> getStringDetails(
    String key,
    String defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });

  FutureOr<num> getNumberValue(
    String key,
    num defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });

  FutureOr<FlagEvaluationDetails<num>> getNumberDetails(
    String key,
    num defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });

  FutureOr<Value> getObjectValue(
    String key,
    Value defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });

  FutureOr<FlagEvaluationDetails<Value>> getObjectDetails(
    String key,
    Value defaultValue, {
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });
}
