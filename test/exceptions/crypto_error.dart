import 'package:test/test.dart';

import 'package:tezart/src/exceptions/crypto_error.dart';

void main() {
  final type = CryptoErrorTypes.prefixNotFound;

  group('when message is set', () {
    final message = 'parameter message';
    final subject = () => CryptoError(type: type, message: message);

    test('it sets type correctly', () {
      expect(subject().type, equals(type));
    });

    test('it sets message using parameter message', () {
      expect(subject().message, equals(message));
    });
  });

  group('when message is not set', () {
    final subject = () => CryptoError(type: type);

    test('it sets type correctly', () {
      expect(subject().type, equals(type));
    });

    test('it sets message using static error messages', () {
      expect(subject().message, equals('Prefix not found'));
    });

    test('it sets key correctly', () {
      expect(subject().key, equals('prefix_not_found'));
    });
  });
}
