// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tezart/src/core/rpc/impl/tezart_http_client.dart';

import 'package:tezart/src/core/rpc/rpc_interface.dart';

import 'tezart_http_client_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  final client = MockDio();
  final options = BaseOptions();
  const url = 'http://localhost:20000/';
  late TezartHttpClient instance;

  void testFailingRequest(Function subject, Function callback) {
    setUp(() {
      when(callback()).thenAnswer((_) async {
        throw DioError(requestOptions: RequestOptions(path: url));
      });
    });

    test('it throws a TezartHttpError', () {
      expect(
        subject,
        throwsA(
          predicate((e) => e is TezartHttpError),
        ),
      );
    });
  }

  setUp(() {
    when(client.options).thenReturn(options);
    instance = TezartHttpClient(url, client: client);
  });

  tearDown(() {
    reset(client);
  });

  group('#post', () {
    const path = '/mempool';
    const data = {'test': 'test'};
    final subject = () => instance.post(path, data: data);

    group('when the request succeeds', () {
      setUp(() {
        when(client.post(path, data: data)).thenAnswer((_) async {
          return Response(
            data: 'ok',
            statusCode: 201,
            requestOptions: RequestOptions(path: url),
          );
        });
      });

      test("calls client's post", () async {
        await subject();

        verifyInOrder([
          client.options,
          client.post(path, data: data),
        ]);

        verifyNoMoreInteractions(client);
      });
    });

    group('when the request fails', () {
      testFailingRequest(subject, () => client.post(path, data: data));
    });
  });

  group('#get', () {
    const path = '/mempool';
    const params = {'test': 'test'};
    final subject = () => instance.get(path, params: params);

    group('when the request succeeds', () {
      setUp(() {
        when(client.get(path, queryParameters: params)).thenAnswer((_) async {
          return Response(
            data: 'ok',
            statusCode: 200,
            requestOptions: RequestOptions(path: url),
          );
        });
      });

      test("calls client's get", () async {
        await subject();

        verifyInOrder([
          client.options,
          client.get(path, queryParameters: params),
        ]);

        verifyNoMoreInteractions(client);
      });
    });

    group('when the request fails', () {
      testFailingRequest(subject, () => client.get(path, queryParameters: params));
    });
  });

  group('#getStream', () {
    const path = '/mempool';
    const params = {'test': 'test'};
    final subject = () => instance.getStream(path, params: params);

    group('when the request succeeds', () {
      setUp(() {
        when(
          client.get<ResponseBody>(
            path,
            queryParameters: params,
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async {
          return Response(
            data: ResponseBody(
              Stream.fromIterable(
                [
                  Uint8List.fromList(json.encode(params).codeUnits),
                ],
              ),
              200,
            ),
            requestOptions: RequestOptions(path: url),
          );
        });
      });

      test("calls client's get", () async {
        await subject();

        verify(client.options);
        expect(
          verify(client.get(path, queryParameters: params, options: captureAnyNamed('options')))
              .captured
              .single
              .responseType,
          ResponseType.stream,
        );
        verifyNoMoreInteractions(client);
      });
    });

    group('when the request fails', () {
      testFailingRequest(
        subject,
        () => client.get(
          path,
          queryParameters: params,
          options: anyNamed('options'),
        ),
      );
    });
  });
}
