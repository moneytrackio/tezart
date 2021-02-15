import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/signature/signature.dart';

void main() {
  const mnemonic =
      'brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';

  test('.random', () {
    final keystore = Keystore.random();
    expect(keystore.mnemonic, isNotNull);
  });

  group('.fromMnemonic', () {
    Keystore keystore;
    setUp(() {
      keystore = Keystore.fromMnemonic(mnemonic);
    });

    test('sets mnemonic correctly', () {
      expect(keystore.mnemonic, mnemonic);
    });

    test('computes secretKey correctly', () {
      expect(keystore.secretKey, 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa');
    });
  });

  group('.fromSecretKey', () {
    Keystore keystore;
    String secretKey;

    setUp(() {
      secretKey = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';
      keystore = Keystore.fromSecretKey(secretKey);
    });

    test('sets secretKey correctly', () {
      expect(keystore.secretKey, secretKey);
    });

    test('sets mnemonic to null', () {
      expect(keystore.mnemonic, null);
    });
  });

  group('compare keystore', () {
    test('is equals', () {
      final k1 = Keystore.fromSecretKey('pouet');
      final k2 = Keystore.fromSecretKey('pouet');
      expect(k1, k2);
    });
    test('is not equals', () {
      final k1 = Keystore.fromSecretKey('pouet');
      final k2 = Keystore.fromSecretKey('yeaahh');
      expect(k1, isNot(k2));
    });
  });

  group('getters', () {
    Keystore keystore;
    setUp(() {
      const secretKey = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';

      keystore = Keystore.fromSecretKey(secretKey);
    });
    test('#publicKey computes the publicKey correctly', () {
      expect(keystore.publicKey, 'edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU');
    });

    test('#address computes correctly', () {
      expect(keystore.address, 'tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW');
    });

    group('#edsk', () {
      String secretKey;

      group('when the secretKey is edsk2 format', () {
        setUp(() {
          secretKey = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';
          keystore = Keystore.fromSecretKey(secretKey);
        });

        test('returns valid edsk format', () {
          expect(keystore.edsk,
              'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap');
        });
      });

      group('when the secretKey is edsk format', () {
        setUp(() {
          secretKey =
              'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';
          keystore = Keystore.fromSecretKey(secretKey);
        });

        test('returns secretKey', () {
          expect(keystore.edsk, secretKey);
        });
      });
    });
  });

  group('signature methods', () {
    final keystore = Keystore.fromMnemonic(mnemonic);

    group('.signBytes', () {
      final bytes = Uint8List.fromList([123, 78, 19]);
      final subject = keystore.signBytes(bytes);

      test('it returns a valid signature', () {
        final result = subject;
        final expectedResult = Signature.fromBytes(bytes: bytes, keystore: keystore);

        expect(result, equals(expectedResult));
      });
    });

    group('.signHex', () {
      final hex = '5483953ab23b';
      final subject = keystore.signHex(hex);

      test('it returns a valid signature', () {
        final result = subject;
        final expectedResult = Signature.fromHex(data: hex, keystore: keystore);

        expect(result, equals(expectedResult));
      });
    });
  });
}
