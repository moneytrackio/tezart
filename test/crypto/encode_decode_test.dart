import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tezart/crypto.dart' as crypto;

void main() {
  final decodedAddress = Uint8List.fromList(<int>[
    133,
    150,
    69,
    73,
    131,
    91,
    131,
    238,
    27,
    209,
    60,
    160,
    78,
    103,
    17,
    231,
    140,
    79,
    21,
    176
  ]);

  final encodedAddress = 'tz1XpNacx7vQ9y8ugdAc8p99LVfjudKjagVq';

  // Encode
  group('.encodeTz', () {
    test('encodes addresses correctly', () {
      expect(crypto.encodeTz(prefix: 'tz1', bytes: decodedAddress),
          encodedAddress);
    });
  });

  // Decode
  group('.decodeTz', () {
    test('decodes an address correctly', () {
      expect(crypto.decodeTz(encodedAddress), decodedAddress);
    });
  });
}
