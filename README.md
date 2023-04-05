[![codecov](https://codecov.io/gh/marandaneto/openfeature-dart-sdk/branch/main/graph/badge.svg)](https://codecov.io/gh/marandaneto/openfeature-dart-sdk)

| package | build | pub | likes | popularity | pub points |
| ------- | ------- | ------- | ------- | ------- | ------- |
| openfeature | [![build](https://github.com/marandaneto/openfeature-dart-sdk/workflows/openfeature/badge.svg)](https://github.com/marandaneto/openfeature-dart-sdk?query=openfeature) | [![pub package](https://img.shields.io/pub/v/openfeature.svg)](https://pub.dev/packages/openfeature) | [![likes](https://img.shields.io/pub/likes/openfeature?logo=dart)](https://pub.dev/packages/openfeature/score) | [![popularity](https://img.shields.io/pub/popularity/openfeature?logo=dart)](https://pub.dev/packages/openfeature/score) | [![pub points](https://img.shields.io/pub/points/openfeature?logo=dart)](https://pub.dev/packages/openfeature/score)

Dart implementation of [OpenFeature](https://openfeature.dev), a vendor-agnostic abstraction library for evaluating feature flags.

This is pretty much experimental and under development as a hobby project.

```dart
import 'package:openfeature/openfeature.dart';

final api = OpenFeatureAPI();
// set your own provider
api.provider = EnvVarProvider();
final client = api.getClient('myClient');
final result = await client.getBooleanValue('myBoolFlag', false);
```

For complete documentation, visit: https://docs.openfeature.dev/docs/category/concepts
