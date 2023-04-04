import 'package:openfeature_dart/src/exceptions/open_feature_error.dart';

import '../error_code.dart';

class ParseError extends OpenFeatureError {
  ParseError(super.message);

  @override
  ErrorCode errorCode = ErrorCode.parseError;
}
