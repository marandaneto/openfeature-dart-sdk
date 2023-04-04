import 'flag_value_type.dart';
import 'hook.dart';

abstract class StringHook implements Hook<String> {
  @override
  bool supportsFlagValueType(FlagValueType flagValueType) =>
      FlagValueType.string == flagValueType;
}
