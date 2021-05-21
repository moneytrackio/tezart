import 'package:test/test.dart';
import 'package:tezart/src/common/utils/enum_util.dart';

enum MonEnum {
  generic,
  transaction,
}

void main() {
  group('.stringToEnum', () {
    group('when the value exists', () {
      test('it returns the enum', () {
        final value = EnumUtil.stringToEnum(MonEnum.values, 'generic');
        expect(value, MonEnum.generic);
      });
    });

    group('when the value doesnt exist', () {
      test('it raises a StateError', () {
        expect(
          () => EnumUtil.stringToEnum(MonEnum.values, 'pouet'),
          throwsA(predicate((e) => e is StateError)),
        );
      });
    });
  });

  test('.enumToString', () {
    final value = EnumUtil.enumToString(MonEnum.transaction);
    expect(value, 'transaction');
  });
}
