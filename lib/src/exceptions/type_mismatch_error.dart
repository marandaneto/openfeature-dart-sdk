import '../error_code.dart';
import 'open_feature_error.dart';

/// The type of the flag value does not match the expected type.
class TypeMismatchError extends OpenFeatureError {
  TypeMismatchError(super.message);

  @override
  ErrorCode get errorCode => ErrorCode.typeMismatch;
}
