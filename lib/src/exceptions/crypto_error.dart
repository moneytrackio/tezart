import 'package:meta/meta.dart';
import 'package:tezart/src/exceptions/tezart_exception.dart';
import 'package:tezart/src/utils/enum_util.dart';

enum ErrorTypes {
  prefixNotFound,
  unknownPrefix,
  unhandled,
}

/// Exception thrown when an error occurs during crypto operation.
class CryptoError implements TezartException {
  final ErrorTypes _inputType;
  final String _inputMessage;
  final dynamic error;

  final staticErrorsMessages = {
    ErrorTypes.prefixNotFound: 'Prefix not found',
    ErrorTypes.unknownPrefix: 'Unknown prefix',
    ErrorTypes.unhandled: 'Unhandled error',
  };

  CryptoError({@required ErrorTypes type, String message, this.error})
      : _inputType = type,
        _inputMessage = message;

  @override
  String toString() {
    return '$runtimeType: got code $key with msg $message.';
  }

  ErrorTypes get type => _inputType;

  @override
  String get message => _inputMessage ?? _computedMessage;

  String get _computedMessage => staticErrorsMessages[type];

  @override
  String get key => EnumUtil.enumToString(type);

  @override
  dynamic get originalException => error;
}
