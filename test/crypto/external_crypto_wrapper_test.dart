import 'package:test/test.dart';
import 'package:tezart/crypto.dart';
import '../utils/common.dart' as common;
import './utils/common.dart' as crypto_common;
import 'expected_results/external_crypto_wrapper.dart' as expected_results;

void main() {
  group('.secretKeyBytesFromMnemonic', () {
    const mnemonic = 'brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';

    test('returns valid SigningKey', () {
      final secretKeyBytes = secretKeyBytesFromMnemonic(mnemonic);
      expect(common.listEquals(secretKeyBytes, expected_results.secretKeyFromMnemonic), true);
    });
  });

  group('.secretKeyBytesFromSeed', () {
    test('returns valid secret key', () {
      final secretKeyBytes = secretKeyBytesFromSeed(crypto_common.fakeUint8List());

      expect(common.listEquals(secretKeyBytes, expected_results.secretKeyBytesFromSeed), true);
    });
  });
}