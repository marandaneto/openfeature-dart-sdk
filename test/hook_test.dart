import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  final hook = MyHook();
  final attributes = {
    'key': Value.fromObject('keyValue'),
  };
  final baseCtx = ImmutableContext.fromAttributes(attributes);
  final hookCtx = HookContext.from<String>(
    'flagKey',
    FlagValueType.string,
    MetadataName('client'),
    MetadataName('provider'),
    baseCtx,
    'defaultValue',
  );

  final eval = ProviderEvaluation<String>(
    'defaultValue',
    Reason.static,
  );
  final details = FlagEvaluationDetails.from<String>(eval, 'flagKey');

  test('base hook does nothing', () {
    expect(hook.supportsFlagValueType(FlagValueType.boolean), true);

    hook.after(hookCtx, details, {});
    hook.before(hookCtx, {});
    hook.error(hookCtx, ArgumentError(''), {});
    hook.finallyAfter(hookCtx, {});
  });
}
