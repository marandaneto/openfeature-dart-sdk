import '../error_code.dart';
import '../value.dart';
import 'open_feature_error.dart';

/// The value can not be converted to a [Value].
class ValueNotConvertableError extends OpenFeatureError {
  ValueNotConvertableError(super.message);

  @override
  ErrorCode get errorCode => ErrorCode.general;
}
