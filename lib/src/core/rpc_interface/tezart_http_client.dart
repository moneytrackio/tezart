import 'package:dio/dio.dart' as http_client;
import 'package:meta/meta.dart';
import 'package:tezart/src/exceptions/tezart_http_error.dart';

class TezartHttpClient {
  http_client.Dio client;
  final String host, port, scheme;

  TezartHttpClient({@required this.host, this.port = '80', this.scheme = 'http'}) {
    final options = http_client.BaseOptions(baseUrl: baseUrl, contentType: 'application/json');
    client = http_client.Dio(options);
  }

  String get baseUrl => '$scheme://$host:$port/';

  Future<http_client.Response> post(String path, {dynamic data}) {
    return _handleClientError(() => client.post(path, data: data));
  }

  Future<http_client.Response> get(String path, {Map<String, dynamic> params}) {
    return _handleClientError(() => client.get(path, queryParameters: params));
  }

  Future<T> _handleClientError<T>(Function func) async {
    try {
      return await func();
    } on http_client.DioError catch (e) {
      throw TezartHttpError(e);
    }
  }
}
