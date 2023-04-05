// SDK classes
export 'src/features.dart';
export 'src/client.dart';
export 'src/metadata.dart';
export 'src/structure.dart';
export 'src/value.dart';
export 'src/evaluation_context.dart';
export 'src/feature_provider.dart';
export 'src/open_feature_api.dart';
export 'src/immutable_structure.dart';
export 'src/provider_evaluation.dart';
export 'src/immutable_context.dart';
export 'src/hook_context.dart';
export 'src/flag_value_type.dart';
export 'src/metadata_name.dart';
export 'src/string_hook.dart';
export 'src/flag_evaluation_details.dart';
export 'src/flag_evaluation_options.dart';
export 'src/hook_support.dart';
export 'src/reason.dart';
export 'src/base_evaluation.dart';
export 'src/boolean_hook.dart';
export 'src/error_code.dart';

// exceptions
export 'src/exceptions/general_error.dart';
export 'src/exceptions/parse_error.dart';
export 'src/exceptions/open_feature_error.dart';
export 'src/exceptions/value_not_convertable_error.dart';
export 'src/exceptions/flag_not_found_error.dart';
export 'src/exceptions/invalid_context_error.dart';
export 'src/exceptions/targeting_key_missing_error.dart';
export 'src/exceptions/type_mismatch_error.dart';

// default providers

// conditional import for dart:io
export 'src/providers/noop_env_var_provider.dart'
    if (dart.library.io) 'src/providers/env_var_provider.dart';

export 'src/providers/no_op_provider.dart';
