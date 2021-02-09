import 'package:dio/dio.dart' as http_client;
import 'package:tezart/src/exceptions/tezart_exception.dart';
import 'package:tezart/src/utils/enum_util.dart';

enum ErrorTypes {
  connectTimeout,
  receiveTimeout,
  response,
  cancel,
  unhandled,
}

// Wrapper around DioError
// complete missing methods if needed
class TezartHttpError implements TezartException {
  final http_client.DioError clientError;
  final staticErrorsMessages = {
    ErrorTypes.connectTimeout: 'Opening connection timed out',
    ErrorTypes.receiveTimeout: 'Receiving connection timed out',
    ErrorTypes.cancel: 'The request has been cancelled',
    ErrorTypes.unhandled: 'Network Error',
  };
  final errorTypesMapping = {
    http_client.DioErrorType.CONNECT_TIMEOUT: ErrorTypes.connectTimeout,
    http_client.DioErrorType.RECEIVE_TIMEOUT: ErrorTypes.receiveTimeout,
    http_client.DioErrorType.RESPONSE: ErrorTypes.response,
    http_client.DioErrorType.CANCEL: ErrorTypes.cancel,
  };

  TezartHttpError(this.clientError);

  dynamic get responseBody => _response?.data;
  int get statusCode => _response?.statusCode;
  ErrorTypes get type => errorTypesMapping[clientError.type] ?? ErrorTypes.unhandled;
  http_client.Response get _response => clientError.response;

  @override
  String get key => EnumUtil.enumToString(type);
  @override
  String get message => _response?.statusMessage ?? staticErrorsMessages[type];
  @override
  http_client.DioError get originalException => clientError;

  @override
  String toString() => '$runtimeType: got key $key with message $message';
}
