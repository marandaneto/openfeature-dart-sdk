import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  const key = 'baseKey';
  const keyValue = 'baseValue';
  final hookSupport = HookSupport();

  test('should merge evaluation context on before hooks', () {
    final attributes = {
      key: Value.fromObject(keyValue),
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

    final fake1 = FakeStringHook({'bla': Value.fromObject('blubber')});
    final fake2 = FakeStringHook({'foo': Value.fromObject('bar')});
    final hooks = [fake1, fake2];

    final result =
        hookSupport.beforeHooks(FlagValueType.string, hookCtx, hooks, {});

    expect(result.getValue('bla')?.asString, 'blubber');
    expect(result.getValue('foo')?.asString, 'bar');
    expect(result.getValue(key)?.asString, keyValue);
  });

  test('should always call generic hook', () {
    final fakeHook = FakeStringHook({});
    final baseCtx = ImmutableContext.empty();

    final ex = ArgumentError('error');
    final hookCtx = HookContext.from<String>(
      'flagKey',
      FlagValueType.string,
      MetadataName('client'),
      MetadataName('provider'),
      baseCtx,
      'defaultValue',
    );
    final hooks = [fakeHook];

    hookSupport.beforeHooks(FlagValueType.string, hookCtx, hooks, {});

    final eval = ProviderEvaluation<String>(
      'defaultValue',
      Reason.static,
    );

    hookSupport.afterHooks(FlagValueType.string, hookCtx,
        FlagEvaluationDetails.from<String>(eval, 'defaultValue'), hooks, {});
    hookSupport.afterAllHooks(FlagValueType.string, hookCtx, hooks, {});
    hookSupport.errorHooks(FlagValueType.string, hookCtx, ex, hooks, {});

    expect(fakeHook.calledBefore, true);
    expect(fakeHook.calledAfter, true);
    expect(fakeHook.calledError, true);
    expect(fakeHook.calledFinallyAfter, true);
  });
}
