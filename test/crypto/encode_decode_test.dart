import 'package:flutter_test/flutter_test.dart';
import 'package:tezart/src/crypto/exception.dart';
import 'package:tezart/crypto.dart' as crypto;
import '../utils/crypto_common.dart' as crypto_common;

void main() {
  final encodedAddress = 'tz1XpNacx7vQ9y8ugdAc8p99LVfjudKjagVq';

  // Encode
  group('.encodeTz', () {
    test('encodes addresses correctly', () {
      expect(
          crypto.encodeTz(prefix: 'tz1', bytes: crypto_common.decodedAddress),
          encodedAddress);
    });

    test('encodes throw error', () {
      expect(
          () => crypto.encodeTz(
              prefix: null, bytes: crypto_common.decodedAddress),
          throwsA(predicate((e) => e is CryptoError)));
    });
  });

  // Decode
  group('.decodeTz', () {
    test('decodes an address correctly', () {
      expect(crypto.decodeTz(encodedAddress), crypto_common.decodedAddress);
    });
  });

  test('.ignorePrefix throw error', () {
    expect(() => crypto.ignorePrefix(crypto_common.fakeUint8List()),
        throwsA(predicate((e) => e is CryptoError)));
  });

  test('.hexPrefix throw error', () {
    expect(() => crypto.hexPrefix(''),
        throwsA(predicate((e) => e is CryptoError)));
  });
}
