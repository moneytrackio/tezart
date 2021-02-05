import 'package:test/test.dart';
import 'package:tezart/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:tezart/env/env.dart';
import 'package:tezart/src/crypto/exception.dart';
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
          throwsA(predicate((e) => e is CryptoError)));
    });
  });

  // Decode
  group('.decodeTz', () {
    test('decodes an address correctly', () {
      expect(crypto.decodeTz(encodedAddress), expected_results.decodedAddress);
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
    expect(() => crypto.ignorePrefix(crypto_common.fakeUint8List()), throwsA(predicate((e) => e is CryptoError)));
  });

  test('.hexPrefix throw error', () {
    expect(() => crypto.hexPrefix(''), throwsA(predicate((e) => e is CryptoError)));
  });
}
