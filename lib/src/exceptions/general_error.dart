import '../../openfeature.dart';
import '../error_code.dart';

class GeneralError extends OpenFeatureError {
  GeneralError(super.message);

  @override
  ErrorCode get errorCode => ErrorCode.general;
}
