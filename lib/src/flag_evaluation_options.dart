import 'hook.dart';

class FlagEvaluationOptions {
  final List<Hook> _hooks;

  final Map<String, Object> _hookHints = {};

  FlagEvaluationOptions._(this._hooks);

  FlagEvaluationOptions.empty() : this._([]);

  FlagEvaluationOptions.from(List<Hook> hooks) : this._(hooks);

  Map<String, Object> get hookHints => Map.unmodifiable(_hookHints);

  List<Hook> get hooks => List.unmodifiable(_hooks);
}
