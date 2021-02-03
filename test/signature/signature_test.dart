import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:tezart/keystore.dart';
import 'package:tezart/signature.dart';

void main() {
  final keystore = KeyStore.fromSecretKey('edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa');

  group('.fromBytes', () {
    final bytes = Uint8List.fromList([432, 59, 54, 09]);
    final subject = Signature.fromBytes(bytes: bytes, keyStore: keystore);

    test('it sets bytes correctly', (){
      expect(subject.bytes, equals(bytes));
    });

    test('it sets keystore correctly', (){
      expect(subject.keyStore, equals(keystore));
    });
  });

  group('.fromHex', () {
    final hex = '12345adf';
    final subject = Signature.fromHex(data: hex, keyStore: keystore);

    test('it sets bytes correctly', (){
      final bytes = [18, 52, 90, 223];

      expect(subject.bytes, equals(bytes));
    });

    test('it sets keystore correctly', (){
      expect(subject.keyStore, equals(keystore));
    });
  });

  group('.signedBytes', () {
    final subject = (String watermark) =>
        Signature.fromHex(data: '123abd43', keyStore: keystore, watermark: watermark).signedBytes;

    group('when watermak is not null', (){
      final result = subject('generic');

      test('it returns a valid signed bytes list', (){
        final expectedResult = Uint8List.fromList([229, 200, 154, 36, 32, 132, 19, 20, 182, 171, 138, 236, 220, 221, 197, 249, 28, 130, 199, 91, 74, 119, 121, 58, 106, 46, 67, 233, 219, 89, 170, 254, 172, 19, 33, 175, 87, 254, 50, 110, 74, 23, 192, 131, 254, 35, 249, 178, 212, 43, 204, 6, 171, 159, 202, 40, 26, 1, 148, 228, 95, 238, 116, 1]);
        expect(result, equals(expectedResult));
      });
    });

    group('when watermak is null', (){
      final result = subject(null);

      test('it returns a valid signed bytes list', (){
        final expectedResult = Uint8List.fromList([134, 66, 236, 139, 243, 129, 54, 21, 127, 15, 182, 124, 172, 50, 74, 29, 45, 186, 68, 32, 239, 78, 235, 120, 229, 125, 143, 113, 250, 81, 51, 113, 15, 147, 236, 109, 70, 210, 70, 113, 132, 194, 20, 146, 9, 60, 32, 73, 135, 63, 9, 174, 164, 45, 132, 98, 183, 118, 219, 210, 203, 241, 241, 2]);
        expect(result, equals(expectedResult));
      });
    });
  });

  group('.edsig', () {
    final subject = () =>
        Signature.fromHex(data: '123abd43', keyStore: keystore, watermark: 'generic').edsig;

    test('it returns a valid edsig signature', (){
      final expectedResult = 'edsigu3sNYboRMWw81pn8YPe4GSVsqv25Y5jWrzvFJN3wNkaUhbsRFzpFfNYX2LiXpyz7Si1TMcqNVTTwy3Q4ACYAopEjaSNb3S';
      expect(subject(), equals(expectedResult));
    });
  });

  group('.hex', () {
    final subject = () =>
        Signature.fromHex(data: '123abd43', keyStore: keystore, watermark: 'generic').hex;

    test('it returns a valid hex signature', (){
      final expectedResult = '123abd43e5c89a2420841314b6ab8aecdcddc5f91c82c75b4a77793a6a2e43e9db59aafeac1321af57fe326e4a17c083fe23f9b2d42bcc06ab9fca281a0194e45fee7401';
      expect(subject(), equals(expectedResult));
    });
  });

  group('equality', () {
    test('two signatures are equal if their data and keystores are equal', () {
      final data = '1234ae';
      final sig1 = Signature.fromHex(data: data, keyStore: keystore);
      final sig2 = Signature.fromHex(data: data, keyStore: keystore);

      expect(sig1, equals(sig2));
    });

    test('two signatures are not equal if their keystores are different and their data are equal', () {
      final data ='1234';
      final keystore2 = KeyStore.fromSecretKey('edsk4CCa2afKwHWGxB5oZd4jvhq6tgd5EzFaryyR4vLdC3nvpjKUG6');
      final sig1 = Signature.fromHex(data: data, keyStore: keystore);
      final sig2 = Signature.fromHex(data: data, keyStore: keystore2);

      expect(sig1, isNot(equals(sig2)));
    });

    test('two signatures are not equal if their datas are different and their keystores are equal', () {
      final data1 ='1234';
      final data2 = '4321';
      final sig1 = Signature.fromHex(data: data1, keyStore: keystore);
      final sig2 = Signature.fromHex(data: data2, keyStore: keystore);

      expect(sig1, isNot(equals(sig2)));
    });
  });
}