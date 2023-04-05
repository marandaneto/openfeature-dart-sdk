import '../error_code.dart';
import 'open_feature_error.dart';

/// The evaluation context does not meet provider requirements.
class InvalidContextError extends OpenFeatureError {
  InvalidContextError(super.message);

  @override
  ErrorCode get errorCode => ErrorCode.invalidContext;
}
