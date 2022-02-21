// ignore_for_file: prefer_function_declarations_over_variables

import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:tezart/src/core/rpc/impl/tezart_http_error.dart';

import '../../env/env.dart';

void main() {
  const data = 'test';
  const statusCode = 500;
  final originalException = DioError(
    response: Response(
      data: data,
      statusCode: statusCode,
      requestOptions: RequestOptions(path: Env.tezosNodeUrl),
    ),
    type: DioErrorType.cancel,
    requestOptions: RequestOptions(path: Env.tezosNodeUrl),
  );
  final instance = TezartHttpError(originalException);

  group('#responseBody', () {
    final subject = () => instance.responseBody;

    test('it returns response body', () {
      expect(subject(), equals(data));
    });
  });

  group('#statusCode', () {
    final subject = () => instance.statusCode;

    test('it returns status code', () {
      expect(subject(), equals(statusCode));
    });
  });

  group('#type', () {
    final subject = () => instance.type;

    test('it returns valid error type', () {
      expect(subject(), equals(TezartHttpErrorTypes.cancel));
    });
  });

  group('#key', () {
    final subject = () => instance.key;

    test('it returns a string representation of type', () {
      expect(subject(), equals('cancel'));
    });
  });

  group('#message', () {
    final subject = () => instance.message;

    test('it returns a valid error message', () {
      expect(subject(), equals('The request has been cancelled'));
    });
  });

  group('#originalException', () {
    final subject = () => instance.originalException;

    test('it returns the original exception object', () {
      expect(subject(), equals(originalException));
    });
  });
}
