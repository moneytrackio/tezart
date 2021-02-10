import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

// internal Library
import 'signature.dart';
import 'crypto.dart' as crypto;

@immutable
class Keystore extends Equatable {
  static const String prefixSecretKey = 'edsk2';
  static const String prefixSecretKeyAlternative = 'edsk';
  static const String prefixPublicKey = 'edpk';
  static const String prefixAdress = 'tz1';

  final String secretKey;

  final String mnemonic;

  const Keystore._({@required this.secretKey, this.mnemonic});

  factory Keystore.fromSecretKey(String secretKey) {
    return Keystore._(secretKey: secretKey);
  }

  factory Keystore.fromMnemonic(String mnemonic) {
    var bytesSecretKey = crypto.secretKeyBytesFromMnemonic(mnemonic);
    var secretKey = crypto.encodeTz(prefix: prefixSecretKey, bytes: bytesSecretKey);

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
    final secretKeyBytes = crypto.decodeTz(secretKey);
    var pk = crypto.publicKeyBytesFromSeed(secretKeyBytes);

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
      sk = crypto.secretKeyBytesFromSeed(crypto.decodeTz(secretKey));
    } catch (e) {
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

  // signature methods
  Signature signBytes(Uint8List bytes) => Signature.fromBytes(bytes: bytes, keystore: this);
  Signature signHex(String data) => Signature.fromHex(data: data, keystore: this);

  @override
  List<Object> get props => [secretKey];
}
