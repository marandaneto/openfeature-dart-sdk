import 'base_evaluation.dart';
import 'error_code.dart';
import 'provider_evaluation.dart';
import 'reason.dart';

/// Contains information about how the evaluation happened, including any resolved values.
class FlagEvaluationDetails<T> extends BaseEvaluation<T> {
  final String _flagKey;
  final T _value;
  final String? _variant;
  final Reason? _reason;
  final ErrorCode? _errorCode;
  final String? _errorMessage;

  FlagEvaluationDetails._(
    this._flagKey,
    this._value, {
    String? variant,
    Reason? reason,
    ErrorCode? errorCode,
    String? errorMessage,
  })  : _errorCode = errorCode,
        _errorMessage = errorMessage,
        _reason = reason,
        _variant = variant;

  String get key => _flagKey;

  @override
  ErrorCode? get errorCode => _errorCode;

  @override
  String? get errorMessage => _errorMessage;

  @override
  Reason? get reason => _reason;

  @override
  T get value => _value;

  @override
  String? get variant => _variant;

  static FlagEvaluationDetails<T> from<T>(
    ProviderEvaluation<T> providerEval,
    String flagKey,
  ) =>
      FlagEvaluationDetails<T>._(
        flagKey,
        providerEval.value,
        variant: providerEval.variant,
        reason: providerEval.reason,
        errorCode: providerEval.errorCode,
        errorMessage: providerEval.errorMessage,
      );
}
