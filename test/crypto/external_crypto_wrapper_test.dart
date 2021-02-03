import 'package:test/test.dart';
import 'package:tezart/crypto.dart';
import '../utils/common.dart' as common;
import './utils/common.dart' as crypto_common;
import 'expected_results/external_crypto_wrapper.dart' as expected_results;

void main() {
  const mnemonic =
      'brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';

  group('.secretKeyBytesFromMnemonic', () {
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

  group('.signDetached', () {
    final secretKey = secretKeyBytesFromMnemonic(mnemonic);

    test('returns valid signature bytes', () {
      final bytes = crypto_common.fakeUint8List();
      final sig = signDetached(bytes: bytes, secretKey: secretKey);

      expect(common.listEquals(sig, expected_results.signatureBytes), true);
    });
  });

  group('.signDetached', () {
    final secretKey = secretKeyBytesFromMnemonic(mnemonic);

    test('returns valid signature bytes', () {
      final expectedSig = [
        203,
        80,
        16,
        44,
        139,
        213,
        158,
        96,
        34,
        53,
        98,
        245,
        153,
        40,
        235,
        186,
        132,
        236,
        91,
        72,
        92,
        234,
        117,
        11,
        26,
        127,
        84,
        185,
        113,
        237,
        11,
        80,
        70,
        113,
        170,
        221,
        240,
        162,
        160,
        165,
        35,
        196,
        63,
        172,
        48,
        180,
        105,
        36,
        104,
        15,
        98,
        90,
        205,
        35,
        174,
        179,
        255,
        23,
        146,
        83,
        169,
        227,
        183,
        7
      ];
      final bytes = crypto_common.fakeUint8List();
      final sig = signDetached(bytes: bytes, secretKey: secretKey);

      expect(common.listEquals(sig, expectedSig), true);
    });
  });
}
