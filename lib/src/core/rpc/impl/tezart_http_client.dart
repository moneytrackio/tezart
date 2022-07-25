import 'dart:io';

import 'package:dio/dio.dart' as http_client;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:logging/logging.dart';
import 'package:retry/retry.dart';

import 'tezart_http_error.dart';

class TezartHttpClient {
  final log = Logger('TezartHttpClient');
  late http_client.Dio client;
  final String url;

  // Add client as optional parameter for testing
  TezartHttpClient(this.url, {http_client.Dio? client}) {
    // ensure that the url ends with '/' (double / is ok)
    final baseUrl = '$url/';

    if (client != null) {
      this.client = client;
      this.client.options.baseUrl = baseUrl;
      return;
    }

    final options = http_client.BaseOptions(baseUrl: baseUrl, contentType: 'application/json');
    this.client = http_client.Dio(options);
    this.client.interceptors.add(PrettyDioLogger(
          logPrint: log.finest,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: false,
        ));
  }

  Future<http_client.Response> post(String path, {dynamic data}) {
    log.info('request to post to path: $path');
    return _retryOnSocketException(
      () => _handleClientError(
        () => client.post(path, data: data),
      ),
    );
  }

  Future<http_client.Response> get(String path, {Map<String, dynamic>? params}) {
    log.info('request to get from path: $path');

    return _retryOnSocketException(
      () => _handleClientError(
        () => client.get(path, queryParameters: params),
      ),
    );
  }

  Future<http_client.Response<http_client.ResponseBody>> getStream(
    String path, {
    Map<String, dynamic>? params,
  }) {
    return _retryOnSocketException(
      () => _handleClientError(
        () => client.get<http_client.ResponseBody>(
          path,
          queryParameters: params,
          options: http_client.Options(
            responseType: http_client.ResponseType.stream,
          ), // set responseType to `stream`
        ),
      ),
    );
  }

  Future<T> _retryOnSocketException<T>(Future<T> Function() func) {
    final r = RetryOptions(maxAttempts: 3);

    return r.retry<T>(
      func,
      retryIf: (e) {
        return e is TezartHttpError && e.originalException is SocketException;
      },
    );
  }

  Future<T> _handleClientError<T>(Function func) async {
    try {
      return await func();
    } on http_client.DioError catch (e) {
      log.severe('Error in http call', e);
      throw TezartHttpError(e);
    }
  }
}
