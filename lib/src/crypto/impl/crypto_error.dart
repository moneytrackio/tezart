import 'package:meta/meta.dart';
import 'package:tezart/src/common/exceptions/common_exception.dart';
import 'package:tezart/src/common/utils/enum_util.dart';

enum CryptoErrorTypes {
  prefixNotFound,
  unknownPrefix,
  seedBytesLengthError,
  seedLengthError,
  secretKeyLengthError,
  unhandled,
}

/// Exception thrown when an error occurs during crypto operation.
class CryptoError extends CommonException {
  final CryptoErrorTypes _inputType;
  final String _inputMessage;
  final dynamic cause;

  final staticErrorsMessages = {
    CryptoErrorTypes.prefixNotFound: 'Prefix not found',
    CryptoErrorTypes.unknownPrefix: 'Unknown prefix',
    CryptoErrorTypes.seedBytesLengthError: 'The seed must be 32 bytes long',
    CryptoErrorTypes.seedLengthError: 'The seed must be 54 characters long',
    CryptoErrorTypes.secretKeyLengthError: 'The secret key must 98 characters long',
    CryptoErrorTypes.unhandled: 'Unhandled error',
  };

  CryptoError({@required CryptoErrorTypes type, String message, this.cause})
      : _inputType = type,
        _inputMessage = message;

  CryptoErrorTypes get type => _inputType;

  @override
  String get message => _inputMessage ?? _computedMessage;

  String get _computedMessage => staticErrorsMessages[type];

  @override
  String get key => EnumUtil.enumToString(type);

  @override
  dynamic get originalException => cause;
}
