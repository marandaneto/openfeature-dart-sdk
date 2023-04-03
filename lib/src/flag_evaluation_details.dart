import 'base_evaluation.dart';
import 'error_code.dart';
import 'provider_evaluation.dart';
import 'reason.dart';

/// Contains information about how the evaluation happened, including any resolved values.
class FlagEvaluationDetails<T> extends BaseEvaluation<T> {
  final String _flagKey;
  final T _value;
  final String _variant;
  final Reason _reason;
  final ErrorCode? _errorCode;
  final String? _errorMessage;

  FlagEvaluationDetails(
    this._flagKey,
    this._value,
    this._variant,
    this._reason,
    this._errorCode,
    this._errorMessage,
  );

  @override
  ErrorCode? getErrorCode() => _errorCode;

  @override
  String? getErrorMessage() => _errorMessage;

  @override
  Reason getReason() => _reason;

  @override
  T getValue() => _value;

  @override
  String getVariant() => _variant;

  static FlagEvaluationDetails<T> from<T>(
    ProviderEvaluation<T> providerEval,
    String flagKey,
  ) =>
      FlagEvaluationDetails<T>(
          flagKey,
          providerEval.getValue(),
          providerEval.getVariant(),
          providerEval.getReason(),
          providerEval.getErrorCode(),
          providerEval.getErrorMessage());
}
