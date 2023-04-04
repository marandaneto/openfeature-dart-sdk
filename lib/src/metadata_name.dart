import 'package:meta/meta.dart';

import 'metadata.dart';

@internal
class MetadataName implements Metadata {
  final String _name;

  MetadataName(this._name);
  
  @override
  String get name => _name;
}
