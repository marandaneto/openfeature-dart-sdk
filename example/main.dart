import 'package:openfeature/openfeature.dart';

Future<void> main(List<String> arguments) async {
  final api = OpenFeatureAPI();
  // set your own provider
  api.provider = EnvVarProvider();
  final client = api.getClient('myClient');
  await client.getBooleanValue('myBoolFlag', false);
}
