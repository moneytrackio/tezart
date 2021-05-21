import 'package:dio/dio.dart' as http_client;
import 'package:tezart/src/common/exceptions/common_exception.dart';
import 'package:tezart/src/common/utils/enum_util.dart';
import 'package:tezart/src/core/client/tezart_client.dart';

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
    http_client.DioErrorType.connectTimeout: TezartHttpErrorTypes.connectTimeout,
    http_client.DioErrorType.receiveTimeout: TezartHttpErrorTypes.receiveTimeout,
    http_client.DioErrorType.response: TezartHttpErrorTypes.response,
    http_client.DioErrorType.cancel: TezartHttpErrorTypes.cancel,
  };

  TezartHttpError(this.clientError);

  dynamic get responseBody => _response?.data;
  int? get statusCode => _response?.statusCode;
  TezartHttpErrorTypes get type {
    return errorTypesMapping[clientError.type] ?? TezartHttpErrorTypes.unhandled;
  }

  http_client.Response? get _response => clientError.response;

  @override
  String get key => EnumUtil.enumToString(type);
  @override
  String get message => _response?.statusMessage ?? staticErrorsMessages[type]!;
  @override
  http_client.DioError get originalException => clientError;
}

Future<T> catchHttpError<T>(Future<T> Function() func, {void Function(TezartHttpError)? onError}) async {
  try {
    return await func();
  } on TezartHttpError catch (e) {
    if (onError != null) onError(e);
    throw TezartNodeError.fromHttpError(e);
  }
}
