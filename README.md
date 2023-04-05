Dart implementation of [OpenFeature](https://openfeature.dev), a vendor-agnostic abstraction library for evaluating feature flags.

This is pretty much experimental and under development as a hobby project.

```dart
final api = OpenFeatureAPI();
// set your own provider
api.provider = EnvVarProvider();
final client = api.getClient('myClient');
final result = await client.getBooleanValue('myBoolFlag', false);
```

For complete documentation, visit: https://docs.openfeature.dev/docs/category/concepts
