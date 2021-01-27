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
    final keyPair = keyPairFromMnemonic(mnemonic);
    final secretKey = crypto.encodeTz(
      prefix: prefixSecretKey,
      bytes: keyPair.sk,
    );

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
    final pk = keyPairFromSeed(secretKeyBytes).pk;

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
      sk = keyPairFromSeed(crypto.decodeTz(secretKey)).sk;
    } on RangeError {
      // RangeError <=> the key is already of type edsk2
      return secretKey;
    }

    return crypto.encodeTz(
      prefix: prefixSecretKeyAlternative,
      bytes: sk,
    );
  }

  @visibleForTesting
  static KeyPair keyPairFromMnemonic(String mnemonic) {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final seedLength32 = seed.sublist(0, 32);
    final keys = keyPairFromSeed(seedLength32);

    final sk = keys.sk.sublist(0, 32);
    final pk = keys.pk;

    return KeyPair(pk: pk, sk: sk);
  }

  @visibleForTesting
  static KeyPair keyPairFromSeed(Uint8List seed) =>
      Sodium.cryptoSignSeedKeypair(seed);

  @override
  List<Object> get props => [secretKey, mnemonic];
}
