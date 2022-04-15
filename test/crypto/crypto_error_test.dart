// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/crypto/crypto.dart';

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
      expect(subject().key, equals('prefixNotFound'));
    });

    test('it converts to string correctly', () {
      expect(subject().toString(), equals('CryptoError: got code prefixNotFound with msg `Prefix not found.`'));
    });

    test('it sets originalException to null', () {
      expect(subject().originalException, equals(null));
    });
  });

  group('when the error type is unhandled', () {
    test('the message is computed dynamically', () {
      final subject = () => CryptoError(type: CryptoErrorTypes.unhandled);
      expect(subject().message, equals('Unhandled error: null'));
    });
  });
}
