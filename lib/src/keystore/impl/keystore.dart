import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

// internal Library
import 'package:tezart/src/crypto/crypto.dart' as crypto hide Prefixes;
import 'package:tezart/src/crypto/crypto.dart' show Prefixes;
import 'package:tezart/src/signature/signature.dart';

@immutable
class Keystore extends Equatable {
  static const Prefixes seedPrefix = Prefixes.edsk2;
  static const Prefixes publicKeyPrefix = Prefixes.edpk;
  static const Prefixes addressPrefix = Prefixes.tz1;
  static const secretKeyLength = 98;
  static const seedLength = 54;

  final String secretKey;

  final String mnemonic;

  const Keystore._({@required this.secretKey, this.mnemonic});

  factory Keystore.fromSecretKey(String secretKey) {
    if (secretKey.length != secretKeyLength) {
      throw crypto.CryptoError(type: crypto.CryptoErrorTypes.secretKeyLengthError);
    }

    return Keystore._(secretKey: secretKey);
  }
  factory Keystore.fromSeed(String seed) {
    if (seed.length != seedLength) {
      throw crypto.CryptoError(type: crypto.CryptoErrorTypes.seedLengthError);
    }

    return Keystore._(secretKey: crypto.seedToSecretKey(seed));
  }

  factory Keystore.fromMnemonic(String mnemonic) {
    var bytesSecretKey = crypto.secretKeyBytesFromMnemonic(mnemonic);
    var secretKey = crypto.encodeWithPrefix(prefix: seedPrefix, bytes: bytesSecretKey);

    return Keystore._(
      secretKey: secretKey,
      mnemonic: mnemonic,
    );
  }

  factory Keystore.random() {
    final generated = crypto.generateMnemonic();
    return Keystore.fromMnemonic(generated);
  }

  String get publicKey {
    final seedBytes = crypto.decodeWithoutPrefix(seed);
    var pk = crypto.publicKeyBytesFromSeedBytes(seedBytes);

    return crypto.encodeWithPrefix(
      prefix: publicKeyPrefix,
      bytes: pk,
    );
  }

  String get address {
    final publicKeyBytes = crypto.decodeWithoutPrefix(publicKey);
    final hash = crypto.hashWithDigestSize(
      size: 160,
      bytes: publicKeyBytes,
    );

    return crypto.encodeWithPrefix(
      prefix: addressPrefix,
      bytes: hash,
    );
  }

  String get seed => crypto.secretKeyToSeed(secretKey);

  // signature methods
  Signature signBytes(Uint8List bytes) => Signature.fromBytes(bytes: bytes, keystore: this);
  Signature signHex(String data) => Signature.fromHex(data: data, keystore: this);

  @override
  List<Object> get props => [secretKey];
}
