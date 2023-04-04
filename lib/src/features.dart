import 'dart:async';

import 'evaluation_context.dart';
import 'flag_evaluation_details.dart';
import 'flag_evaluation_options.dart';

/// An API for the type-specific fetch methods offered to users.
abstract class Features {
  FutureOr<bool> getBooleanValue(
    String key, {
    bool defaultValue,
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });

  FutureOr<FlagEvaluationDetails<bool>> getBooleanDetails(
    String key, {
    bool defaultValue,
    EvaluationContext? evaluationContext,
    FlagEvaluationOptions? options,
  });
}
