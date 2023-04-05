import 'package:openfeature/openfeature.dart';

class FakeStringHook extends StringHook {
  final Map<String, Value> _attributes;
  FakeStringHook(this._attributes);

  var calledBefore = false;
  var calledAfter = false;
  var calledError = false;
  var calledFinallyAfter = false;

  @override
  EvaluationContext? before(
      HookContext<String> evaluationContext, Map<String, Object> hints) {
    calledBefore = true;
    return ImmutableContext.fromAttributes(_attributes);
  }

  @override
  void after(HookContext<String> ctx, FlagEvaluationDetails<String> details,
      Map<String, Object> hints) {
    calledAfter = true;
  }

  @override
  void error(HookContext<String> ctx, Object error, Map<String, Object> hints) {
    calledError = true;
  }

  @override
  void finallyAfter(HookContext<String> ctx, Map<String, Object> hints) {
    calledFinallyAfter = true;
  }
}

class FakeBooleanHook extends BooleanHook {}

class FakeNumberHook extends NumberHook {}

class MyHook extends Hook<String> {}

class FakeNonValue {}
