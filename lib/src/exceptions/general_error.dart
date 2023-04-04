import 'package:openfeature_dart/src/error_code.dart';
import 'package:openfeature_dart/src/exceptions/open_feature_error.dart';

class GeneralError extends OpenFeatureError {
  GeneralError(super.message);

  @override
  ErrorCode get errorCode => ErrorCode.general;
}
