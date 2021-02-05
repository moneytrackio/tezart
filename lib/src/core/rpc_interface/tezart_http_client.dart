import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class TezartHttpClient {
  Dio client;
  final String host, port, scheme;

  TezartHttpClient({@required this.host, this.port = '80', this.scheme = 'http'}) {
    final options = BaseOptions(baseUrl: baseUrl, contentType: 'application/json');
    client = Dio(options);
  }

  String get baseUrl => '$scheme://$host:$port/';

  Future<Response> post(String path, {dynamic data}) {
    return client.post(path, data: data);
  }

  Future<Response> get(String path, {Map<String, dynamic> params}) {
    return client.get(path, queryParameters: params);
  }
}
