import '../error_code.dart';
import 'open_feature_error.dart';

class ValueNotConvertableError extends OpenFeatureError {
  ValueNotConvertableError(super.message);

  @override
  ErrorCode get errorCode => ErrorCode.general;
}
