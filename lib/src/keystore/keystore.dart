/// A library that allows key stores generation and secret key, public key, address computation
///
/// It exposes:
/// - [Keystore]
/// - [CryptoError]
library keystore;

export 'impl/keystore.dart';
export 'package:tezart/src/crypto/crypto.dart' show CryptoError;
