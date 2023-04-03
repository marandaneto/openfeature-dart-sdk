import 'package:openfeature_dart/openfeature.dart';
import 'package:openfeature_dart/src/no_op_provider.dart';

void main(List<String> arguments) {
  final api = OpenFeatureAPI();
  api.provider = NoOpProvider();
  final client = api.getClient();
  final result = client.getBooleanValue('test', defaultValue: true);
  print(result);
}
