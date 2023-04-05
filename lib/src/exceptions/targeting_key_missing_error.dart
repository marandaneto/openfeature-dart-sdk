import '../error_code.dart';
import 'open_feature_error.dart';

/// The provider requires a targeting key and one was not provided in the evaluation context.
class TargetingKeyMissingError extends OpenFeatureError {
  TargetingKeyMissingError(super.message);

  @override
  ErrorCode get errorCode => ErrorCode.targetingKeyMissing;
}
