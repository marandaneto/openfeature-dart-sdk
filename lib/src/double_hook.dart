import 'flag_value_type.dart';
import 'hook.dart';

abstract class DoubleHook extends Hook<double> {
  @override
  bool supportsFlagValueType(FlagValueType flagValueType) =>
      FlagValueType.double == flagValueType;
}
