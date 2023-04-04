import 'package:openfeature_dart/openfeature.dart';
// import 'package:openfeature_dart/src/flagd_provider.dart';

void main(List<String> arguments) async {
  final api = OpenFeatureAPI();
  // api.provider = FlagdProvider(
  //     'https://raw.githubusercontent.com/open-feature/flagd/main/samples/example_flags.flagd.json');
  api.provider = EnvVarProvider();
  final client = api.getClient('name');
  final result =
      await client.getBooleanValue('myBoolFlag', defaultValue: false);
  print(result);
}
