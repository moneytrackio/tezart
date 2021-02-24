import 'dart:typed_data';

import 'package:tezart/src/crypto/impl/prefixes.dart';
import 'package:tezart/tezart.dart';

import 'crypto_error.dart';
import 'encode_decode.dart';
import 'external_crypto_wrapper.dart';

// 1. Convert secret key to bytes
// 2. Cut first 4 bytes representing the prefix
// 3. Take first 32 bytes representing the secret key
// 4. encode the result using edsk2 prefix
// returns the seed of the secret key
String secretKeyToSeed(String secretKey) {
  const seedPrefix = Prefixes.edsk2;
  final bytes = Uint8List.fromList(decodeTz(secretKey).take(32).toList());

  return encodeTz(
    prefix: seedPrefix,
    bytes: bytes,
  );
}

String seedToSecretKey(String seed) {
  const secretKeyPrefix = Prefixes.edsk;

  final seedBytes = decodeTz(seed);
  if (seedBytes.length != 32) throw CryptoError(type: CryptoErrorTypes.seedLengthError);

  final secretKey = secretKeyBytesFromSeedBytes(seedBytes);

  return encodeTz(
    prefix: secretKeyPrefix,
    bytes: secretKey,
  );
}
