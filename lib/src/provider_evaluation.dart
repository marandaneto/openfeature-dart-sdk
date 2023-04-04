import 'base_evaluation.dart';
import 'error_code.dart';
import 'reason.dart';

class ProviderEvaluation<T> implements BaseEvaluation<T> {
  final T _value;
  final String? _variant;
  final Reason _reason;
  final ErrorCode? _errorCode;
  final String? _errorMessage;

  ProviderEvaluation(
    this._value,
    this._reason, {
    String? variant,
    ErrorCode? errorCode,
    String? errorMessage,
  })  : _errorCode = errorCode,
        _errorMessage = errorMessage,
        _variant = variant;

  @override
  ErrorCode? get errorCode => _errorCode;

  @override
  String? get errorMessage => _errorMessage;

  @override
  Reason get reason => _reason;

  @override
  T get value => _value;

  @override
  String? get variant => _variant;
}
