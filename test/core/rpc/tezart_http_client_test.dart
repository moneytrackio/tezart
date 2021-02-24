import 'package:test/test.dart';
import 'package:tezart/src/core/rpc/impl/tezart_http_client.dart';

void main() {
  group('#baseUrl()', () {
    final host = 'example.com';
    final scheme = 'https';
    final subject = (String port) => TezartHttpClient(
          host: host,
          port: port,
          scheme: scheme,
        ).baseUrl;

    group('when the port is not empty', () {
      final port = '8080';

      test('it returns a valid url', () {
        final result = subject(port);

        expect(result, equals('https://example.com:8080/'));
      });
    });

    group('when the port is empty', () {
      final port = '';

      test('it returns a valid url', () {
        expect(subject(port), equals('https://example.com/'));
      });
    });
  });
}
