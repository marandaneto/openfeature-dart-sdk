import 'package:openfeature/openfeature.dart';

void main(List<String> arguments) async {
  final api = OpenFeatureAPI();
  // set your own provider
  api.provider = EnvVarProvider();
  final client = api.getClient('myClient');
  final result =
      await client.getBooleanValue('myBoolFlag', defaultValue: false);
  print(result);
}
