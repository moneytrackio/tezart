import 'package:test/test.dart';
import 'package:tezart/crypto.dart';
import '../utils/common.dart' as common;
import './utils/common.dart' as crypto_common;

void main() {
  group('.secretKeyBytesFromMnemonic', () {
    const mnemonic = 'brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';

    test('returns valid SigningKey', () {
      final expectedSk = [ 98, 205, 166, 170, 210, 8, 237, 237, 195, 178, 37, 31, 210, 237, 240, 73, 87, 247, 165, 70, 0, 137, 133, 110, 21, 130, 35, 21, 173, 194, 215, 96 ];

      final secretKeyBytes = secretKeyBytesFromMnemonic(mnemonic);
      expect(common.listEquals(secretKeyBytes, expectedSk), true);
    });
  });

  group('.secretKeyBytesFromSeed', () {
    test('returns valid secret key', () {
      final expectedSk = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 121, 181, 86, 46, 143, 230, 84, 249, 64, 120, 177, 18, 232, 169, 139, 167, 144, 31, 133, 58, 230, 149, 190, 215, 224, 227, 145, 11, 173, 4, 150, 100 ];

      final secretKeyBytes = secretKeyBytesFromSeed(crypto_common.fakeUint8List());

      expect(common.listEquals(secretKeyBytes, expectedSk), true);
    });
  });
}