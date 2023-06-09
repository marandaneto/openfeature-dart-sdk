import 'error_code.dart';
import 'reason.dart';

/// This is a common interface between the evaluation results that providers return and what is given to the end users.
abstract class BaseEvaluation<T> {
  T get value;

  String? get variant;

  Reason? get reason;

  ErrorCode? get errorCode;

  String? get errorMessage;
}
