import '../../openfeature.dart';
import '../error_code.dart';

class ParseError extends OpenFeatureError {
  ParseError(super.message);

  @override
  ErrorCode errorCode = ErrorCode.parseError;
}
