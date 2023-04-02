import 'flag_value_type.dart';
import 'hook.dart';

abstract class BooleanHook extends Hook<bool> {
  @override
  bool supportsFlagValueType(FlagValueType flagValueType) =>
      FlagValueType.boolean == flagValueType;
}
