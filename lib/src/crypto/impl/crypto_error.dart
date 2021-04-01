import 'package:meta/meta.dart';
import 'package:tezart/src/common/exceptions/common_exception.dart';
import 'package:tezart/src/common/utils/enum_util.dart';

/// Exhaustive list of cryptographic error types.
enum CryptoErrorTypes {
  /// Prefix not found error.
  ///
  /// Happens when :
  /// - trying to encode with an unknown prefix.
  /// - trying to ignore an unknown prefix.
  prefixNotFound,

  /// Invalid seed bytes length
  ///
  /// Happens when the seed bytes length is != 32.
  seedBytesLengthError,

  /// Invalid (string) seed length.
  ///
  /// Happens when the seed length is != 54.
  seedLengthError,

  /// Invalid (string) secret key length.
  ///
  /// Happens when the secret key length is != 98.
  secretKeyLengthError,

  /// Invalid (string) encrypted secret key length.
  ///
  /// Happens when the encrypted secret key length is != 88.
  encryptedSecretKeyLengthError,

  /// Invalid mnemonic.
  ///
  /// Happens when :
  /// - the mnemonic is short.
  /// - the mnemonic contains an unknown word.
  invalidMnemonic,

  /// Invalid checksum.
  ///
  /// Happens when :
  /// - the checksum of a secret key is invalid.
  /// - the checksum of a seed is invalid.
  invalidChecksum,

  /// Hexadecimal data length is odd.
  ///
  /// Happens when the length of an hexadecimal representation of a list of bytes is odd.
  invalidHexDataLength,

  /// Invalid hexadecimal string.
  ///
  /// Happens when the hexadecimal string contains invalid characters (`[a-fA-F0-9]`).
  invalidHex,

  /// Unhandled error.
  unhandled,
}

/// Exception thrown when an error occurs during a cryptographic operation.
///
/// You can translate the error messages using [key] or [type].
///
/// ```dart
/// try {
///   aCryptoOperation();
/// } on CryptoError catch (e) {
///   print(e.message); // 'Prefix not found'
///   print(e.key); // 'prefixNotFound'
/// }
class CryptoError extends CommonException {
  final CryptoErrorTypes _inputType;
  final String _inputMessage;
  final dynamic cause;

  final staticErrorsMessages = {
    CryptoErrorTypes.prefixNotFound: 'Prefix not found',
    CryptoErrorTypes.seedBytesLengthError: 'The seed must be 32 bytes long',
    CryptoErrorTypes.seedLengthError: 'The seed must be 54 characters long',
    CryptoErrorTypes.secretKeyLengthError: 'The secret key must 98 characters long',
    CryptoErrorTypes.invalidMnemonic: 'The mnemonic is invalid',
    CryptoErrorTypes.invalidChecksum: 'Invalid checksum',
    CryptoErrorTypes.invalidHexDataLength: "Hexadecimal data's length must be even",
    CryptoErrorTypes.invalidHex: 'Invalid hexadecimal',
  };
  final dynamicErrorMessages = {
    CryptoErrorTypes.unhandled: (dynamic e) => 'Unhandled error: $e',
  };

  /// Default constructor.
  ///
  /// - [type] is required.
  /// - [message] is optional. If provided, it will be used.
  ///     If not, it will use `staticErrorMessages[type]` or `dynamicErrorMessages[type]` (in this priority order).
  /// - [cause] is optional, it represents the error that caused this.
  CryptoError({@required CryptoErrorTypes type, String message, this.cause})
      : _inputType = type,
        _inputMessage = message;

  /// Type of this.
  CryptoErrorTypes get type => _inputType;

  /// Human readable explanation of this.
  @override
  String get message => _inputMessage ?? _computedMessage;

  String get _computedMessage {
    if (staticErrorsMessages.containsKey(type)) {
      return staticErrorsMessages[type];
    }

    switch (type) {
      case CryptoErrorTypes.unhandled:
        return dynamicErrorMessages[type](cause);

        break;
      default:
        throw UnimplementedError('Unimplemented error type $type');

        break;
    }
  }

  /// String representation of type.
  @override
  String get key => EnumUtil.enumToString(type);

  /// Cause of this, might be null.
  ///
  /// It represents the error that caused this.
  @override
  dynamic get originalException => cause;
}

T catchUnhandledErrors<T>(T Function() func) {
  try {
    return func();
  } catch (e) {
    if (e is CryptoError) {
      rethrow;
    }
    throw CryptoError(type: CryptoErrorTypes.unhandled, cause: e);
  }
}
