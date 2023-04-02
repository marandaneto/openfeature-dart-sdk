import 'dart:developer';

import 'flag_evaluation_details.dart';
import 'flag_value_type.dart';
import 'hook.dart';
import 'hook_context.dart';

typedef HookConsumer = void Function(Hook param);

class HookSupport {
  void errorHooks(
    FlagValueType flagValueType,
    HookContext hookCtx,
    Object e,
    List<Hook> hooks,
    Map<String, Object> hints,
  ) {
    void theHook(Hook hook) {
      hook.error(hookCtx, e, hints);
    }

    _executeHooks(flagValueType, hooks, "error", theHook);
  }

  void afterAllHooks(
    FlagValueType flagValueType,
    HookContext hookCtx,
    List<Hook> hooks,
    Map<String, Object> hints,
  ) {
    void theHook(Hook hook) {
      hook.finallyAfter(hookCtx, hints);
    }

    _executeHooks(flagValueType, hooks, "finally", theHook);
  }

  void afterHooks(
    FlagValueType flagValueType,
    HookContext hookContext,
    FlagEvaluationDetails details,
    List<Hook> hooks,
    Map<String, Object> hints,
  ) {
    void theHook(Hook hook) {
      hook.after(hookContext, details, hints);
    }

    _executeHooksUnchecked(flagValueType, hooks, theHook);
  }

  void _executeHooks(
    FlagValueType flagValueType,
    List<Hook> hooks,
    String hookMethod,
    HookConsumer consumer,
  ) {
    hooks
        .where((element) => element.supportsFlagValueType(flagValueType))
        .forEach((element) => _executeChecked(element, consumer, hookMethod));
  }

  void _executeHooksUnchecked(
    FlagValueType flagValueType,
    List<Hook> hooks,
    HookConsumer consumer,
  ) {
    hooks
        .where((element) => element.supportsFlagValueType(flagValueType))
        .forEach(consumer);
  }

  void _executeChecked(Hook hook, HookConsumer consumer, String hookMethod) {
    try {
      consumer(hook);
    } catch (e, stackTrace) {
      log(
        "Error in $hookMethod hook: $hook",
        error: e,
        stackTrace: stackTrace,
        name: 'openfeature',
      );
    }
  }

  // TODO: missing beforeHooks, callBeforeHooks
}
