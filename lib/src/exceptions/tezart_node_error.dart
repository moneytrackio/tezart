import 'package:meta/meta.dart';

import 'tezart_http_error.dart' as client_error;
import 'tezart_exception.dart';
import 'package:tezart/src/utils/enum_util.dart';

enum ErrorTypes {
  already_revealed_key,
  unhandled,
}

class TezartNodeError implements TezartException {
  final client_error.TezartHttpError error;
  final ErrorTypes _inputType;
  final String _inputMessage;

  final staticErrorsMessages = {
    ErrorTypes.already_revealed_key: 'You\'re trying to reveal an already revealed key.',
    ErrorTypes.unhandled: 'Unhandled error',
  };

  TezartNodeError({@required ErrorTypes type, String message})
      : _inputType = type,
        _inputMessage = message,
        error = null;
  TezartNodeError.fromHttpError(this.error)
      : _inputType = null,
        _inputMessage = null;

  ErrorTypes get type => _inputType ?? _computedType;

  @override
  String get message => _inputMessage ?? _computedMessage;

  ErrorTypes get _computedType {
    if (RegExp(r'previously_revealed_key').hasMatch(errorId)) return ErrorTypes.already_revealed_key;

    return ErrorTypes.unhandled;
  }

  // TODO: what to do when there is multiple errors ?
  String get errorId => error?.responseBody?.first['id'];

  @override
  String get key => EnumUtil.enumToString(type);

  String get _computedMessage => staticErrorsMessages[type];

  @override
  client_error.TezartHttpError get originalException => error;

  @override
  String toString() => '$runtimeType: got key $key with message $message';
}
