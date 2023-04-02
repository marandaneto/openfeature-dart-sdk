import 'evaluation_context.dart';
import 'flag_evaluation_details.dart';

/// An API for the type-specific fetch methods offered to users.
abstract class Features {
  bool getBooleanValue(String key, {bool defaultValue, EvaluationContext? ctx});

  FlagEvaluationDetails<bool> getBooleanDetails(
    String key, {
    bool defaultValue,
    EvaluationContext? ctx,
  });
}
