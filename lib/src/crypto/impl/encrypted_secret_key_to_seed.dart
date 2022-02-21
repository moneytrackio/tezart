import 'package:pinenacl/x25519.dart';
import 'package:tezart/src/crypto/crypto.dart' as crypto hide Prefixes;
import 'package:tezart/src/crypto/crypto.dart' show Prefixes;

String encryptedSecretKeyToSeed({
  required String encryptedSecretKey,
  required String passphrase,
}) {
  final bytes = crypto.decodeWithoutPrefix(encryptedSecretKey);
  final salt = bytes.sublist(0, 8);
  final secretKeyBytes = bytes.sublist(8);
  const iterationCount = 32768;
  const keyLength = 32;
  final nonce = Uint8List(24);

  final encryptionKey = crypto.deriveBits(
    passphrase: Uint8List.fromList(passphrase.codeUnits),
    salt: salt,
    iterationCount: iterationCount,
    keyLength: keyLength,
  );

  final secretbox = SecretBox(encryptionKey);
  final decryptedBytes = secretbox.decrypt(ByteList.fromList(secretKeyBytes), nonce: nonce);

  final seed = crypto.encodeWithPrefix(
    prefix: Prefixes.edsk2,
    bytes: decryptedBytes,
  );

  return seed;
}
