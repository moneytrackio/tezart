part of 'package:tezart/keystore.dart';

@immutable
class KeyStore extends Equatable {
  static final String prefixSecretKey = 'edsk2';
  static final String prefixSecretKeyAlternative = 'edsk';
  static final String prefixPublicKey = 'edpk';
  static final String prefixAdress = 'tz1';

  final String secretKey;

  final String mnemonic;

  const KeyStore._({@required this.secretKey, this.mnemonic});

  factory KeyStore.fromSecretKey(String secretKey) {
    return KeyStore._(secretKey: secretKey);
  }

  factory KeyStore.fromMnemonic(String mnemonic) {
    var bytesSecretKey = generateSecretKeyBytesFromMnemonic(mnemonic);
    var secretKey = crypto.encodeTz(prefix: 'edsk2', bytes: bytesSecretKey);

    return KeyStore._(
      secretKey: secretKey,
      mnemonic: mnemonic,
    );
  }

  factory KeyStore.random() {
    final generated = crypto.generateMnemonic();
    return KeyStore.fromMnemonic(generated);
  }

  String get publicKey {
    final secretKeyBytes = crypto.decodeTz(secretKey);
    var pk = secretKeyFromSeed(secretKeyBytes).verifyKey;

    return crypto.encodeTz(
      prefix: prefixPublicKey,
      bytes: pk,
    );
  }

  String get address {
    final publicKeyBytes = crypto.decodeTz(publicKey);
    final hash = crypto.hashWithDigestSize(
      size: 160,
      bytes: publicKeyBytes,
    );

    return crypto.encodeTz(
      prefix: prefixAdress,
      bytes: hash,
    );
  }

  // returns the edsk format of the secret key
  String get edsk {
    Uint8List sk;

    try {
      sk = secretKeyFromSeed(crypto.decodeTz(secretKey));

      } catch(e) {
        if (RegExp(r'SigningKey must be created from a 32 byte seed').hasMatch(e.message)) {
          return secretKey;
        }
        rethrow;
      }

    return crypto.encodeTz(
      prefix: prefixSecretKeyAlternative,
      bytes: sk,
    );
  }

  @visibleForTesting
  static ByteList generateSecretKeyBytesFromMnemonic(String mnemonic) {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final seedLength32 = seed.sublist(0, 32);

    return secretKeyFromSeed(seedLength32).sublist(0, 32);
  }

  @visibleForTesting
  static SigningKey secretKeyFromSeed(Uint8List seed) =>
      SigningKey.fromSeed(seed);

  @override
  List<Object> get props => [secretKey];
}
