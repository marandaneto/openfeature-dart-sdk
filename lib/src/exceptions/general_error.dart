import '../error_code.dart';
import 'open_feature_error.dart';

class GeneralError extends OpenFeatureError {
  GeneralError(super.message);

  @override
  ErrorCode get errorCode => ErrorCode.general;
}
