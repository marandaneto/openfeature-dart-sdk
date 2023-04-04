import 'package:meta/meta.dart';

import 'metadata.dart';

@internal
class MetadataName implements Metadata {
  final String? _name;

  MetadataName({String? name}) : _name = name;

  @override
  String? getName() => _name;
}
