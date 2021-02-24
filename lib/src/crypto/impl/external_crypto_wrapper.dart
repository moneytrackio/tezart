import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:meta/meta.dart';
import 'package:pinenacl/api.dart';
import 'package:tezart/tezart.dart';

import 'crypto_error.dart';

// These methods are a wrapper of (Nacl|PineNacl|Bouncy Castle) lib methods
Uint8List seedBytesFromMnemonic(String mnemonic, {String passphrase = ''}) {
  if (!bip39.validateMnemonic(mnemonic)) throw CryptoError(type: CryptoErrorTypes.invalidMnemonic);

  final seedBytes = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase);

  return seedBytes.sublist(0, 32);
}

Uint8List secretKeyBytesFromSeedBytes(Uint8List seed) => signingKeyFromSeedBytes(seed);

Uint8List publicKeyBytesFromSeedBytes(Uint8List seed) => signingKeyFromSeedBytes(seed).verifyKey;

@visibleForTesting
SigningKey signingKeyFromSeedBytes(Uint8List seed) => SigningKey.fromSeed(seed);

Uint8List signDetached({@required Uint8List bytes, @required Uint8List secretKey}) {
  final seed = secretKey.sublist(0, 32); // the seed is the first 32 bytes of the secret key

  return SigningKey(seed: seed).sign(bytes).sublist(0, 64);
}
