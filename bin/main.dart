import 'package:openfeature_dart/openfeature.dart';

void main(List<String> arguments) {
  final api = OpenFeatureAPI();
  // api.provider = NoOpProvider();
  final client = api.getClient('name');
  final result = client.getBooleanValue('test', defaultValue: true);
  print(result);
}
