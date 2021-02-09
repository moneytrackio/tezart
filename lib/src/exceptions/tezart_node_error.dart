import 'tezart_http_error.dart' as client_error;
import 'tezart_exception.dart';
import 'package:tezart/src/utils/enum_util.dart';

enum ErrorTypes {
  already_revealed_key,
  unhandled,
}

class TezartNodeError implements TezartException {
  final client_error.TezartHttpError error;
  final staticErrorsMessages = {
    ErrorTypes.already_revealed_key: 'You\'re trying to reveal an already revealed key.',
    ErrorTypes.unhandled: 'Unhandled error',
  };

  TezartNodeError(this.error);

  ErrorTypes get type {
    if (noResponseError) return ErrorTypes.unhandled;
    if (RegExp(r'previously_revealed_key').hasMatch(errorId)) return ErrorTypes.already_revealed_key;

    return ErrorTypes.unhandled;
  }

  // TODO: what to do when there is multiple errors ?
  String get errorId => error?.responseBody?.first['id'];

  @override
  // Return client error's key if no response from the node
  String get key => noResponseError ? error.key : EnumUtil.enumToString(type);

  @override
  // Return client error's message if no response from the node
  String get message => noResponseError ? error.message : staticErrorsMessages[type];

  bool get noResponseError => error.type != client_error.ErrorTypes.response;

  @override
  client_error.TezartHttpError get originalException => error;

  @override
  String toString() => '$runtimeType: got key $key with message $message';
}
