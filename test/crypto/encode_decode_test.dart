import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:tezart/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:tezart/env/env.dart';
import 'package:tezart/src/crypto/exception.dart';
import './utils/common.dart' as crypto_common;

void main() {
  final encodedAddress = 'tz1XpNacx7vQ9y8ugdAc8p99LVfjudKjagVq';
  final decodedAddress = Uint8List.fromList(<int>[ 133, 150, 69, 73, 131, 91, 131, 238, 27, 209, 60, 160, 78, 103, 17, 231, 140, 79, 21, 176 ]);

  // Encode
  group('.encodeTz', () {
    test('encodes addresses correctly', () {
      expect(
          crypto.encodeTz(prefix: 'tz1', bytes: decodedAddress),
          encodedAddress);
    });

    test('encodes throw error', () {
      expect(
          () => crypto.encodeTz(
              prefix: null, bytes: decodedAddress),
          throwsA(predicate((e) => e is CryptoError)));
    });
  });

  // Decode
  group('.decodeTz', () {
    test('decodes an address correctly', () {
      expect(crypto.decodeTz(encodedAddress), decodedAddress);
    });
  });

  // TODO: remove this test when a test calling the node is implemented
  test('ci', () async {
    final host = Env.tezosNodeHost;
    final port = Env.tezosNodePort;
    final scheme = Env.tezosNodeScheme;
    final baseUrl = '$scheme://$host:$port';
    var response = await http.get('$baseUrl/chains/main/mempool/pending_operations');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    expect(response.statusCode, 200);
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
