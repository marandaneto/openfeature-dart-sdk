import 'evaluation_context.dart';
import 'flag_evaluation_details.dart';
import 'flag_value_type.dart';
import 'hook_context.dart';

/// An extension point which can run around flag resolution.
/// They are intended to be used as a way to add custom logic to the lifecycle of flag evaluation.
abstract class Hook<T> {
  EvaluationContext? before(HookContext<T> ctx, Map<String, Object> hints) =>
      null;

  void after(HookContext<T> ctx, FlagEvaluationDetails<T> details,
      Map<String, Object> hints) {}

  void error(HookContext<T> ctx, Object error, Map<String, Object> hints) {}

  void finallyAfter(HookContext<T> ctx, Map<String, Object> hints) {}

  bool supportsFlagValueType(FlagValueType flagValueType) => true;
}
