import 'package:meta/meta.dart';
import 'package:tezart/src/exceptions/tezart_exception.dart';
import 'package:tezart/src/utils/enum_util.dart';

enum CryptoErrorTypes {
  prefixNotFound,
  unknownPrefix,
  unhandled,
}

/// Exception thrown when an error occurs during crypto operation.
class CryptoError extends TezartException {
  final CryptoErrorTypes _inputType;
  final String _inputMessage;
  final dynamic error;

  final staticErrorsMessages = {
    CryptoErrorTypes.prefixNotFound: 'Prefix not found',
    CryptoErrorTypes.unknownPrefix: 'Unknown prefix',
    CryptoErrorTypes.unhandled: 'Unhandled error',
  };

  CryptoError({@required CryptoErrorTypes type, String message, this.error})
      : _inputType = type,
        _inputMessage = message;

  CryptoErrorTypes get type => _inputType;

  @override
  String get message => _inputMessage ?? _computedMessage;

  String get _computedMessage => staticErrorsMessages[type];

  @override
  String get key => EnumUtil.enumToString(type);

  @override
  dynamic get originalException => error;
}
