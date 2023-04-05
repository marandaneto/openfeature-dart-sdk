import '../error_code.dart';
import 'open_feature_error.dart';

class FlagNotFoundError extends OpenFeatureError {
  FlagNotFoundError(super.message);

  @override
  ErrorCode get errorCode => ErrorCode.flagNotFound;
}
