import '../error_code.dart';

abstract class OpenFeatureError implements Exception {
  final String _message;

  OpenFeatureError(this._message);

  @override
  String toString() => _message;

  ErrorCode get errorCode;
}
