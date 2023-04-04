import 'hook.dart';

class FlagEvaluationOptions {
  final List<Hook> _hooks;

  final Map<String, Object> _hookHints;

  FlagEvaluationOptions._(this._hooks, this._hookHints);

  FlagEvaluationOptions.empty() : this._([], {});

  FlagEvaluationOptions.fromHooks(List<Hook> hooks) : this._(hooks, {});

  FlagEvaluationOptions.from(List<Hook> hooks, Map<String, Object> hookHints)
      : this._(hooks, hookHints);

  Map<String, Object> get hookHints => Map.unmodifiable(_hookHints);

  List<Hook> get hooks => List.unmodifiable(_hooks);
}
