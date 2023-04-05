import 'package:openfeature/openfeature.dart';
import 'package:test/test.dart';

void main() {
  test('$FlagNotFoundError returns error code', () {
    final e = FlagNotFoundError('error');

    expect(e.errorCode, ErrorCode.flagNotFound);
    expect(e.toString(), 'error');
  });

  test('$GeneralError returns error code', () {
    final e = GeneralError('error');

    expect(e.errorCode, ErrorCode.general);
    expect(e.toString(), 'error');
  });

  test('$InvalidContextError returns error code', () {
    final e = InvalidContextError('error');

    expect(e.errorCode, ErrorCode.invalidContext);
    expect(e.toString(), 'error');
  });

  test('$ParseError returns error code', () {
    final e = ParseError('error');

    expect(e.errorCode, ErrorCode.parseError);
    expect(e.toString(), 'error');
  });

  test('$TargetingKeyMissingError returns error code', () {
    final e = TargetingKeyMissingError('error');

    expect(e.errorCode, ErrorCode.targetingKeyMissing);
    expect(e.toString(), 'error');
  });

  test('$TypeMismatchError returns error code', () {
    final e = TypeMismatchError('error');

    expect(e.errorCode, ErrorCode.typeMismatch);
    expect(e.toString(), 'error');
  });

  test('$ValueNotConvertableError returns error code', () {
    final e = ValueNotConvertableError('error');

    expect(e.errorCode, ErrorCode.general);
    expect(e.toString(), 'error');
  });
}
