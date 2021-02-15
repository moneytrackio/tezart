import 'package:test/test.dart';
import 'package:tezart/src/core/rpc/impl/tezart_http_client.dart';

void main() {
  group('#baseUrl()', () {
    test('it returns a valid url', () async {
      final result = TezartHttpClient(host: 'example.com', port: '8080', scheme: 'https').baseUrl;

      expect(result, equals('https://example.com:8080/'));
    });
  });
}
