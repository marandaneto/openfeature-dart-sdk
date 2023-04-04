import 'flag_value_type.dart';
import 'hook.dart';

abstract class NumberHook extends Hook<num> {
  @override
  bool supportsFlagValueType(FlagValueType flagValueType) =>
      FlagValueType.number == flagValueType;
}
