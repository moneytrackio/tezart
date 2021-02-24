import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:tezart/src/signature/signature.dart';
import 'package:tezart/tezart.dart';

import 'expected_results/signature.dart' as expected_results;

void main() {
  final keystore = Keystore.fromSecretKey('edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa');

  group('.fromBytes', () {
    final bytes = Uint8List.fromList([432, 59, 54, 09]);
    final subject = Signature.fromBytes(bytes: bytes, keystore: keystore);

    test('it sets bytes correctly', () {
      expect(subject.bytes, equals(bytes));
    });

    test('it sets keystore correctly', () {
      expect(subject.keystore, equals(keystore));
    });
  });

  group('.fromHex', () {
    final hex = '12345adf';
    final subject = Signature.fromHex(data: hex, keystore: keystore);

    test('it sets bytes correctly', () {
      final bytes = [18, 52, 90, 223];

      expect(subject.bytes, equals(bytes));
    });

    test('it sets keystore correctly', () {
      expect(subject.keystore, equals(keystore));
    });
  });

  group('.signedBytes', () {
    final subject =
        (String watermark) => Signature.fromHex(data: '123abd43', keystore: keystore, watermark: watermark).signedBytes;

    group('when watermak is not null', () {
      final result = subject('generic');

      test('it returns a valid signed bytes list', () {
        expect(result, equals(expected_results.signedBytesWithGenericWatermark));
      });
    });

    group('when watermak is null', () {
      final result = subject(null);

      test('it returns a valid signed bytes list', () {
        expect(result, equals(expected_results.signedBytesWithNullWatermark));
      });
    });
  });

  group('.edsig', () {
    final subject = () => Signature.fromHex(data: '123abd43', keystore: keystore, watermark: 'generic').edsig;

    test('it returns a valid edsig signature', () {
      final expectedResult =
          'edsigu3sNYboRMWw81pn8YPe4GSVsqv25Y5jWrzvFJN3wNkaUhbsRFzpFfNYX2LiXpyz7Si1TMcqNVTTwy3Q4ACYAopEjaSNb3S';
      expect(subject(), equals(expectedResult));
    });
  });

  group('.hex', () {
    final subject = () => Signature.fromHex(data: '123abd43', keystore: keystore, watermark: 'generic').hex;

    test('it returns a valid hex signature', () {
      final expectedResult =
          '123abd43e5c89a2420841314b6ab8aecdcddc5f91c82c75b4a77793a6a2e43e9db59aafeac1321af57fe326e4a17c083fe23f9b2d42bcc06ab9fca281a0194e45fee7401';
      expect(subject(), equals(expectedResult));
    });
  });

  group('equality', () {
    test('two signatures are equal if their data and keystores are equal', () {
      final data = '1234ae';
      final sig1 = Signature.fromHex(data: data, keystore: keystore);
      final sig2 = Signature.fromHex(data: data, keystore: keystore);

      expect(sig1, equals(sig2));
    });

    test('two signatures are not equal if their keystores are different and their data are equal', () {
      final data = '1234';
      final keystore2 = Keystore.fromSecretKey('edsk4CCa2afKwHWGxB5oZd4jvhq6tgd5EzFaryyR4vLdC3nvpjKUG6');
      final sig1 = Signature.fromHex(data: data, keystore: keystore);
      final sig2 = Signature.fromHex(data: data, keystore: keystore2);

      expect(sig1, isNot(equals(sig2)));
    });

    test('two signatures are not equal if their datas are different and their keystores are equal', () {
      final data1 = '1234';
      final data2 = '4321';
      final sig1 = Signature.fromHex(data: data1, keystore: keystore);
      final sig2 = Signature.fromHex(data: data2, keystore: keystore);

      expect(sig1, isNot(equals(sig2)));
    });
  });
}
