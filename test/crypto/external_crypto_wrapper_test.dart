import 'package:test/test.dart';
import 'package:tezart/src/crypto/crypto.dart';
import 'utils/common.dart' as crypto_common;
import 'expected_results/external_crypto_wrapper.dart' as expected_results;

void main() {
  const mnemonic =
      'brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';

  group('.secretKeyBytesFromMnemonic', () {
    test('returns valid SigningKey', () {
      final secretKeyBytes = seedBytesFromMnemonic(mnemonic);
      expect(secretKeyBytes, equals(expected_results.secretKeyFromMnemonic));
    });
  });

  group('.secretKeyBytesFromSeed', () {
    test('returns valid secret key', () {
      final secretKeyBytes = secretKeyBytesFromSeedBytes(crypto_common.fakeUint8List());

      expect(secretKeyBytes, equals(expected_results.secretKeyBytesFromSeed));
    });
  });

  group('.signDetached', () {
    final secretKey = seedBytesFromMnemonic(mnemonic);

    test('returns valid signature bytes', () {
      final bytes = crypto_common.fakeUint8List();
      final sig = signDetached(bytes: bytes, secretKey: secretKey);

      expect(sig, equals(expected_results.signatureBytes));
    });
  });
}
