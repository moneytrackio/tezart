import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

// internal Library
//
// we hide Prefixes from the crypto name and then show it without a name to avoid this:
// `static const crypto.Prefixes seedPrefix = crypto.Prefixes.edsk2;`
// and have this instead :
// `static const Prefixes = Prefixes.edsk2;
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
    return crypto.catchUnhandledErrors(() {
      if (secretKey.length != secretKeyLength) {
        throw crypto.CryptoError(type: crypto.CryptoErrorTypes.secretKeyLengthError);
      }
      _validateChecksum(secretKey);

      return Keystore._(secretKey: secretKey);
    });
  }

  factory Keystore.fromSeed(String seed) {
    return crypto.catchUnhandledErrors(() {
      if (seed.length != seedLength) {
        throw crypto.CryptoError(type: crypto.CryptoErrorTypes.seedLengthError);
      }
      _validateChecksum(seed);

      return Keystore._(secretKey: crypto.seedToSecretKey(seed));
    });
  }

  factory Keystore.fromMnemonic(String mnemonic, {String email = '', String password = ''}) {
    return crypto.catchUnhandledErrors(() {
      final passphrase = '$email$password';
      final seedBytes = crypto.seedBytesFromMnemonic(mnemonic, passphrase: passphrase);
      final seed = crypto.encodeWithPrefix(prefix: seedPrefix, bytes: seedBytes);
      final secretKey = crypto.seedToSecretKey(seed);

      return Keystore._(
        secretKey: secretKey,
        mnemonic: mnemonic,
      );
    });
  }

  factory Keystore.random() {
    return crypto.catchUnhandledErrors(() {
      final generated = crypto.generateMnemonic();
      return Keystore.fromMnemonic(generated);
    });
  }

  String get publicKey {
    return crypto.catchUnhandledErrors(() {
      final seedBytes = crypto.decodeWithoutPrefix(seed);
      var pk = crypto.publicKeyBytesFromSeedBytes(seedBytes);

      return crypto.encodeWithPrefix(
        prefix: publicKeyPrefix,
        bytes: pk,
      );
    });
  }

  String get address {
    return crypto.catchUnhandledErrors(() {
      final publicKeyBytes = crypto.decodeWithoutPrefix(publicKey);
      final hash = crypto.hashWithDigestSize(
        size: 160,
        bytes: publicKeyBytes,
      );

      return crypto.encodeWithPrefix(
        prefix: addressPrefix,
        bytes: hash,
      );
    });
  }

  String get seed {
    return crypto.catchUnhandledErrors(() {
      return crypto.secretKeyToSeed(secretKey);
    });
  }

  // signature methods
  Signature signBytes(Uint8List bytes) {
    return crypto.catchUnhandledErrors(() {
      return Signature.fromBytes(bytes: bytes, keystore: this);
    });
  }

  Signature signHex(String data) {
    return crypto.catchUnhandledErrors(() {
      return Signature.fromHex(data: data, keystore: this);
    });
  }

  @override
  List<Object> get props => [secretKey];

  // TODO: refactor : ChecksumValidator
  static void _validateChecksum(String string) {
    if (!crypto.isChecksumValid(string)) {
      throw crypto.CryptoError(type: crypto.CryptoErrorTypes.invalidChecksum);
    }
  }
}
