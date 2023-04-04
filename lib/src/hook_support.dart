import 'dart:developer';

import 'evaluation_context.dart';
import 'flag_evaluation_details.dart';
import 'flag_value_type.dart';
import 'hook.dart';
import 'hook_context.dart';

typedef HookConsumer = void Function(Hook param);

class HookSupport {
  void errorHooks(
    FlagValueType flagValueType,
    HookContext hookContext,
    Object error,
    List<Hook> hooks,
    Map<String, Object> hints,
  ) {
    void theHook(Hook hook) {
      hook.error(hookContext, error, hints);
    }

    _executeHooks(flagValueType, hooks, "error", theHook);
  }

  void afterAllHooks(
    FlagValueType flagValueType,
    HookContext hookContext,
    List<Hook> hooks,
    Map<String, Object> hints,
  ) {
    void theHook(Hook hook) {
      hook.finallyAfter(hookContext, hints);
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

  EvaluationContext beforeHooks(
    FlagValueType flagValueType,
    HookContext hookContext,
    List<Hook> hooks,
    Map<String, Object> hints,
  ) {
    final result = callBeforeHooks(flagValueType, hookContext, hooks, hints);

    final reduce = result.isNotEmpty
        ? result.reduce((accumulated, current) => accumulated.merge(current))
        : null;
    return hookContext.evaluationContext.merge(reduce);
  }

  List<EvaluationContext> callBeforeHooks(
    FlagValueType flagValueType,
    HookContext hookContext,
    List<Hook> hooks,
    Map<String, Object> hints,
  ) {
    // These traverse backwards from normal.
    final reversedHooks = hooks.reversed.toList();
    return reversedHooks
        .where((element) => element.supportsFlagValueType(flagValueType))
        .map((hook) => hook.before(hookContext, hints))
        .whereType<EvaluationContext>()
        .toList();
  }
}
