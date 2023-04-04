import 'flag_value_type.dart';
import 'hook.dart';

abstract class IntegerHook extends Hook<int> {
  @override
  bool supportsFlagValueType(FlagValueType flagValueType) =>
      FlagValueType.integer == flagValueType;
}
