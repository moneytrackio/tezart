import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:tezart/crypto.dart' as crypto;
import 'package:tezart/src/exceptions/crypto_error.dart';
import '../utils/common.dart';
import './utils/common.dart' as crypto_common;
import 'expected_results/encode_decode.dart' as expected_results;

void main() {
  final encodedAddress = 'tz1XpNacx7vQ9y8ugdAc8p99LVfjudKjagVq';

  // Encode
  group('.encodeTz', () {
    test('encodes addresses correctly', () {
      expect(crypto.encodeTz(prefix: 'tz1', bytes: expected_results.decodedAddress), encodedAddress);
    });

    test('encodes throw error', () {
      expect(() => crypto.encodeTz(prefix: null, bytes: expected_results.decodedAddress),
          throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.prefixNotFound)));
    });
  });

  // Decode
  group('.decodeTz', () {
    test('decodes an address correctly', () {
      expect(crypto.decodeTz(encodedAddress), expected_results.decodedAddress);
    });
  });

  test('.ignorePrefix throw error', () {
    expect(() => crypto.ignorePrefix(crypto_common.fakeUint8List()),
        throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.unknownPrefix)));
  });

  test('.hexPrefix throw error', () {
    expect(() => crypto.hexPrefix(''),
        throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.prefixNotFound)));
  });

  test('.hexDecode', () {
    final encodedString = '12346789abcdef';
    final expectedResult = [18, 52, 103, 137, 171, 205, 239];
    final result = crypto.hexDecode(encodedString);

    expect(listEquals(result, expectedResult), true);
  });

  test('.hexEncode', () {
    final decodedList = Uint8List.fromList([1, 200, 434, 292]);
    final expectedResult = '01c8b224';
    final result = crypto.hexEncode(decodedList);

    expect(result, equals(expectedResult));
  });
}
