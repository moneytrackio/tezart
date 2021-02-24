import 'package:dio/dio.dart' as http_client;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'tezart_http_error.dart';

class TezartHttpClient {
  final log = Logger('TezartHttpClient');
  http_client.Dio client;
  final String host, port, scheme;

  TezartHttpClient({@required this.host, this.port = '', this.scheme = 'http'}) {
    final options = http_client.BaseOptions(baseUrl: baseUrl, contentType: 'application/json');
    client = http_client.Dio(options);
  }

  String get baseUrl => '$scheme://$host${(port != null && port.isEmpty) ? '' : ':$port'}/';

  Future<http_client.Response> post(String path, {dynamic data}) {
    log.info('request to post to path: $path');
    return _handleClientError(() => client.post(path, data: data));
  }

  Future<http_client.Response> get(String path, {Map<String, dynamic> params}) {
    log.info('request to get from path: $path');
    return _handleClientError(() => client.get(path, queryParameters: params));
  }

  Future<http_client.Response<http_client.ResponseBody>> getStream(
    String path, {
    Map<String, dynamic> params,
  }) {
    return _handleClientError(() => client.get<http_client.ResponseBody>(
          path,
          queryParameters: params,
          options: http_client.Options(
            responseType: http_client.ResponseType.stream,
          ), // set responseType to `stream`
        ));
  }

  Future<T> _handleClientError<T>(Function func) async {
    try {
      return await func();
    } on http_client.DioError catch (e) {
      log.severe('Error in revealKey', e);
      throw TezartHttpError(e);
    }
  }
}
