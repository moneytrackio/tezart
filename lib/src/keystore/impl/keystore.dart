import 'dart:typed_data';
import 'package:blockchain_signer/blockchain_signer.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

// internal Library
//
// we hide Prefixes from the crypto name and then show it without a name to avoid this:
// `static const crypto.Prefixes _seedPrefix = crypto.Prefixes.edsk2;`
// and have this instead :
// `static const Prefixes = Prefixes.edsk2;
import 'package:tezart/src/crypto/crypto.dart' as crypto hide Prefixes;
import 'package:tezart/src/crypto/crypto.dart' show Prefixes;
import 'package:tezart/src/signature/signature.dart';

/// A class that handles keystores and keys (seed, secret key, public key, address) computation.
///
/// - [secretKey] is always set
/// - [mnemonic] might be null
@immutable
class Keystore extends Equatable {
  static const Prefixes _seedPrefix = Prefixes.edsk2;
  static const Prefixes _publicKeyPrefix = Prefixes.edpk;
  static const Prefixes _addressPrefix = Prefixes.tz1;
  static const _secretKeyLength = 98;
  static const _encryptedSecretKeyLength = 88;
  static const _seedLength = 54;

  final String secretKey;

  final String? mnemonic;

  RemoteSigner? signer;

  Keystore._({required this.secretKey, this.mnemonic});

  /// Generate a keyStore with a remote signer
  ///
  /// ```dart
  /// await magic.tezos.fetchRemoteSigner();
  /// Keystore.fromRemoteSigner(magic.tezos);
  /// ```
  Keystore.fromRemoteSigner(RemoteSigner this.signer) : secretKey = '', mnemonic = null;

  /// A factory that generates a keystore from a secret key.
  ///
  /// ```dart
  /// final keystore = Keystore.fromSecretKey('edskRpm2mUhvoUjHjXgMoDRxMKhtKfww1ixmWiHCWhHuMEEbGzdnz8Ks4vgarKDtxok7HmrEo1JzkXkdkvyw7Rtw6BNtSd7MJ7');
  /// ```
  ///
  /// Throws [CryptoError] if :\
  /// - [secretKey] length is != 98
  /// - [secretKey] checksum is invalid
  factory Keystore.fromSecretKey(String secretKey) {
    return crypto.catchUnhandledErrors(() {
      if (secretKey.length != _secretKeyLength) {
        throw crypto.CryptoError(type: crypto.CryptoErrorTypes.secretKeyLengthError);
      }
      _validateChecksum(secretKey);

      return Keystore._(secretKey: secretKey);
    });
  }

  /// A factory that generates a keystore from a seed.
  ///
  /// ```dart
  /// final keystore = Keystore.fromSeed('edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa');
  /// ```
  ///
  /// Throws [CryptoError] if:\
  /// - [seed] length is != 54
  /// - [seed] checksum is invalid
  factory Keystore.fromSeed(String seed) {
    return crypto.catchUnhandledErrors(() {
      if (seed.length != _seedLength) {
        throw crypto.CryptoError(type: crypto.CryptoErrorTypes.seedLengthError);
      }
      _validateChecksum(seed);

      return Keystore._(secretKey: crypto.seedToSecretKey(seed));
    });
  }

  /// A factory that generates a key store from a mnemonic, email and password (for fundraisers).\
  ///
  /// [email] and [password] are optional.\
  /// ```dart
  /// final keystore = Keystore.fromMnemonic('brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what');
  /// ```
  ///
  /// Throws [CryptoError] if [mnemonic] is invalid.
  factory Keystore.fromMnemonic(String mnemonic, {String email = '', String password = ''}) {
    return crypto.catchUnhandledErrors(() {
      final passphrase = '$email$password';
      final seedBytes = crypto.seedBytesFromMnemonic(mnemonic, passphrase: passphrase);
      final seed = crypto.encodeWithPrefix(prefix: _seedPrefix, bytes: seedBytes);
      final secretKey = crypto.seedToSecretKey(seed);

      return Keystore._(
        secretKey: secretKey,
        mnemonic: mnemonic,
      );
    });
  }

  factory Keystore.fromEncryptedSecretKey(
    String encryptedSecretKey,
    String passphrase,
  ) {
    return crypto.catchUnhandledErrors(() {
      if (encryptedSecretKey.length != _encryptedSecretKeyLength) {
        throw crypto.CryptoError(type: crypto.CryptoErrorTypes.encryptedSecretKeyLengthError);
      }

      final seed = crypto.encryptedSecretKeyToSeed(
        encryptedSecretKey: encryptedSecretKey,
        passphrase: passphrase,
      );

      return Keystore.fromSeed(seed);
    });
  }

  /// A factory that generates a random key store.\
  ///
  /// ```dart
  /// final keystore = Keystore.random();
  /// ```
  factory Keystore.random() {
    return crypto.catchUnhandledErrors(() {
      final generated = crypto.generateMnemonic();
      return Keystore.fromMnemonic(generated);
    });
  }

  /// The public key of this.
  String get publicKey => crypto.catchUnhandledErrors(() {
    if (signer != null) {
      return signer?.publicKey as String;
    }

    final seedBytes = crypto.decodeWithoutPrefix(seed);
    var pk = crypto.publicKeyBytesFromSeedBytes(seedBytes);

    return crypto.encodeWithPrefix(
      prefix: _publicKeyPrefix,
      bytes: Uint8List.fromList(pk.toList()),
    );
  });

  /// The address of this.
  String get address => crypto.catchUnhandledErrors(() {
    if (signer != null) {
      return signer?.address as String;
    }

    final publicKeyBytes = crypto.decodeWithoutPrefix(publicKey);
    final hash = crypto.hashWithDigestSize(
      size: 160,
      bytes: publicKeyBytes,
    );

    return crypto.encodeWithPrefix(
      prefix: _addressPrefix,
      bytes: hash,
    );

  });

  /// The seed of this.
  String get seed => crypto.catchUnhandledErrors(() {
        return crypto.secretKeyToSeed(secretKey);
      });

  /// Returns [tezart.Signature] of [bytes] signed by this.
  Signature signBytes(Uint8List bytes) => crypto.catchUnhandledErrors(() {
        return Signature.fromBytes(bytes: bytes, keystore: this);
      });

  /// Returns [tezart.Signature] of [data] signed by this.
  Signature signHex(String data) => crypto.catchUnhandledErrors(() {
        return Signature.fromHex(data: data, keystore: this);
      });

  @override
  List<Object> get props => [secretKey];

  // TODO: refactor : ChecksumValidator
  static void _validateChecksum(String string) {
    if (!crypto.isChecksumValid(string)) {
      throw crypto.CryptoError(type: crypto.CryptoErrorTypes.invalidChecksum);
    }
  }
}
