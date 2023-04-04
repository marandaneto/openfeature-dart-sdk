import 'dart:convert';

import '../error_code.dart';
import '../evaluation_context.dart';
import '../feature_provider.dart';
import '../metadata.dart';
import '../metadata_name.dart';
import '../provider_evaluation.dart';

import 'package:http/http.dart' as http;

import '../reason.dart';

// ```json
// {
//   "flags": {
//     "myBoolFlag": {
//       "state": "ENABLED",
//       "variants": {
//         "on": true,
//         "off": false
//       },
//       "defaultVariant": "on"
//     },
//     "myStringFlag": {
//       "state": "ENABLED",
//       "variants": {
//         "key1": "val1",
//         "key2": "val2"
//       },
//       "defaultVariant": "key1"
//     },
//     "myFloatFlag": {
//       "state": "ENABLED",
//       "variants": {
//         "one": 1.23,
//         "two": 2.34
//       },
//       "defaultVariant": "one"
//     },
//     "myIntFlag": {
//       "state": "ENABLED",
//       "variants": {
//         "one": 1,
//         "two": 2
//       },
//       "defaultVariant": "one"
//     },
//     "myObjectFlag": {
//       "state": "ENABLED",
//       "variants": {
//         "object1": {
//           "key": "val"
//         },
//         "object2": {
//           "key": true
//         }
//       },
//       "defaultVariant": "object1"
//     },
//     "isColorYellow": {
//       "state": "ENABLED",
//       "variants": {
//         "on": true,
//         "off": false
//       },
//       "defaultVariant": "off",
//       "targeting": {
//         "if": [
//           {
//             "==": [
//               {
//                 "var": [
//                   "color"
//                 ]
//               },
//               "yellow"
//             ]
//           },
//           "on",
//           "off"
//         ]
//       }
//     },
//     "fibAlgo": {
//       "variants": {
//         "recursive": "recursive",
//         "memo": "memo",
//         "loop": "loop",
//         "binet": "binet"
//       },
//       "defaultVariant": "recursive",
//       "state": "ENABLED",
//       "targeting": {
//         "if": [
//           {
//             "$ref": "emailWithFaas"
//           }, "binet", null
//         ]
//       }
//     },
//     "headerColor": {
//       "variants": {
//         "red": "#FF0000",
//         "blue": "#0000FF",
//         "green": "#00FF00",
//         "yellow": "#FFFF00"
//       },
//       "defaultVariant": "red",
//       "state": "ENABLED",
//       "targeting": {
//         "if": [
//           {
//             "$ref": "emailWithFaas"
//           },
//           {
//             "fractionalEvaluation": [
//               "email",
//               [
//                 "red",
//                 25
//               ],
//               [
//                 "blue",
//                 25
//               ],
//               [
//                 "green",
//                 25
//               ],
//               [
//                 "yellow",
//                 25
//               ]
//             ]
//           }, null
//         ]
//       }
//     }
//   },
//   "$evaluators": {
//     "emailWithFaas": {
//       "in": ["@faas.com", {
//         "var": ["email"]
//       }]
//     }
//   }
// }
// ```

// TODO: this should be a package
// This is not finished/tested
class FlagdProvider extends FeatureProvider {
  static const _name = 'Flagd Provider';

  final Uri _uri;

  final _client = http.Client();

  final _metadata = MetadataName(_name);

  FlagdProvider(String url) : _uri = Uri.parse(url);

  @override
  Future<ProviderEvaluation<bool>> getBooleanEvaluation(
    String key,
    bool defaultValue, {
    EvaluationContext? evaluationContext,
  }) async {
    try {
      final response = await _client.get(_uri);
      final map =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final flags = map['flags'] as Map<String, dynamic>?;
      final theFlag = flags?[key] as Map<String, dynamic>?;
      final defaultVariant = theFlag?['defaultVariant'] as String?;
      final variants = theFlag?['variants'] as Map<String, dynamic>?;
      final variant = variants?[defaultVariant] as bool?;
      final reason = variant == null ? Reason.defaultReason : Reason.split;

      return ProviderEvaluation<bool>(
        variant ?? defaultValue,
        reason,
        variant: defaultVariant ?? '',
      );
    } catch (e) {
      return ProviderEvaluation<bool>(
        defaultValue,
        Reason.defaultReason,
        errorCode: ErrorCode.flagNotFound,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Metadata get metadata => _metadata;
}
