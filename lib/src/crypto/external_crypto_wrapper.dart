part of 'package:tezart/crypto.dart';

// These methods are a wrapper of (Nacl|PineNacl|Bouncy Castle) lib methods
Uint8List secretKeyBytesFromMnemonic(String mnemonic) {
  final seed = bip39.mnemonicToSeed(mnemonic);
  final seedLength32 = seed.sublist(0, 32);

  return secretKeyBytesFromSeed(seedLength32).sublist(0, 32);
}

Uint8List secretKeyBytesFromSeed(Uint8List seed) =>
    signingKeyFromSeed(seed);

Uint8List publicKeyBytesFromSeed(Uint8List seed) =>
    signingKeyFromSeed(seed).verifyKey;

@visibleForTesting
SigningKey signingKeyFromSeed(Uint8List seed) =>
  SigningKey.fromSeed(seed);