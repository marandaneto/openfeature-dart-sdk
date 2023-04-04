import 'package:openfeature_dart/openfeature.dart';
import 'package:openfeature_dart/src/flagd_provider.dart';

void main(List<String> arguments) {
  final api = OpenFeatureAPI();
  api.provider = FlagdProvider(
      'https://raw.githubusercontent.com/open-feature/flagd/main/samples/example_flags.flagd.json');
  final client = api.getClient('name');
  final result = client.getBooleanValue('myBoolFlag', defaultValue: false);
  print(result);
}
