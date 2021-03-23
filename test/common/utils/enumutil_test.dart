import 'package:test/test.dart';
import 'package:tezart/src/common/utils/enum_util.dart';

enum MonEnum {
  generic,
  transaction,
}

void main() {
  test('.stringToEnum', () {
    final value = EnumUtil.stringToEnum(MonEnum.values, 'generic');
    expect(value, MonEnum.generic);

    final nothing = EnumUtil.stringToEnum(MonEnum.values, 'pouet');
    expect(nothing, isNull);
  });

  test('.enumToString', () {
    final value = EnumUtil.enumToString(MonEnum.transaction);
    expect(value, 'transaction');
  });
}
