class OpenFeatureError implements Exception {
  final String _message;

  OpenFeatureError(this._message);

  @override
  String toString() => _message;
}
