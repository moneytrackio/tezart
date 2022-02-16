import 'package:bip39/bip39.dart' as bip39;
import 'package:meta/meta.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:tezart/tezart.dart';

import 'crypto_error.dart';

// These methods are a wrapper of (Nacl|PineNacl|Bouncy Castle) lib methods
Uint8List seedBytesFromMnemonic(String mnemonic, {String passphrase = ''}) {
  if (!bip39.validateMnemonic(mnemonic)) {
    throw CryptoError(type: CryptoErrorTypes.invalidMnemonic);
  }

  final seedBytes = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase);

  return seedBytes.sublist(0, 32);
}

ByteList secretKeyBytesFromSeedBytes(Uint8List seed) => signingKeyFromSeedBytes(seed);

ByteList publicKeyBytesFromSeedBytes(Uint8List seed) => signingKeyFromSeedBytes(seed).verifyKey;

@visibleForTesting
SigningKey signingKeyFromSeedBytes(Uint8List seed) => SigningKey(seed: seed);

ByteList signDetached({required Uint8List bytes, required Uint8List secretKey}) {
  final seed = secretKey.sublist(0, 32); // the seed is the first 32 bytes of the secret key

  return SigningKey(seed: seed).sign(bytes).sublist(0, 64);
}
