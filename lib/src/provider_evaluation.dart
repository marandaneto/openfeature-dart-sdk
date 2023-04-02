import 'base_evaluation.dart';
import 'error_code.dart';
import 'reason.dart';

class ProviderEvaluation<T> implements BaseEvaluation<T> {
  final T _value;
  // TODO: make optional params
  final String _variant;
  final Reason _reason;
  final ErrorCode? _errorCode;
  final String? _errorMessage;

  ProviderEvaluation(
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
}
