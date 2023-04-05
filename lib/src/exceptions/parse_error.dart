import '../error_code.dart';
import 'open_feature_error.dart';

/// An error was encountered parsing data, such as a flag configuration.
class ParseError extends OpenFeatureError {
  ParseError(super.message);

  @override
  ErrorCode errorCode = ErrorCode.parseError;
}
