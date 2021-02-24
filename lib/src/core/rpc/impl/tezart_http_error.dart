import 'package:dio/dio.dart' as http_client;
import 'package:tezart/src/common/exceptions/common_exception.dart';
import 'package:tezart/src/common/utils/enum_util.dart';

enum TezartHttpErrorTypes {
  connectTimeout,
  receiveTimeout,
  response,
  cancel,
  unhandled,
}

// Wrapper around DioError
// complete missing methods if needed
class TezartHttpError extends CommonException {
  final http_client.DioError clientError;
  final staticErrorsMessages = {
    TezartHttpErrorTypes.connectTimeout: 'Opening connection timed out',
    TezartHttpErrorTypes.receiveTimeout: 'Receiving connection timed out',
    TezartHttpErrorTypes.cancel: 'The request has been cancelled',
    TezartHttpErrorTypes.unhandled: 'Network Error',
  };
  final errorTypesMapping = {
    http_client.DioErrorType.CONNECT_TIMEOUT: TezartHttpErrorTypes.connectTimeout,
    http_client.DioErrorType.RECEIVE_TIMEOUT: TezartHttpErrorTypes.receiveTimeout,
    http_client.DioErrorType.RESPONSE: TezartHttpErrorTypes.response,
    http_client.DioErrorType.CANCEL: TezartHttpErrorTypes.cancel,
  };

  TezartHttpError(this.clientError);

  dynamic get responseBody => _response?.data;
  int get statusCode => _response?.statusCode;
  TezartHttpErrorTypes get type {
    return errorTypesMapping[clientError.type] ?? TezartHttpErrorTypes.unhandled;
  }

  http_client.Response get _response => clientError.response;

  @override
  String get key => EnumUtil.enumToString(type);
  @override
  String get message => _response?.statusMessage ?? staticErrorsMessages[type];
  @override
  http_client.DioError get originalException => clientError;
}
