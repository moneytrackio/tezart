import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:tezart/keystore.dart';
import 'package:tezart/signature.dart';

void main() {
  const mnemonic =
      'brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';

  test('.random', () {
    final keyStore = KeyStore.random();
    expect(keyStore.mnemonic, isNotNull);
  });

  group('.fromMnemonic', () {
    KeyStore keyStore;
    setUp(() {
      keyStore = KeyStore.fromMnemonic(mnemonic);
    });

    test('sets mnemonic correctly', () {
      expect(keyStore.mnemonic, mnemonic);
    });

    test('computes secretKey correctly', () {
      expect(keyStore.secretKey, 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa');
    });
  });

  group('.fromSecretKey', () {
    KeyStore keyStore;
    String secretKey;

    setUp(() {
      secretKey = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';
      keyStore = KeyStore.fromSecretKey(secretKey);
    });

    test('sets secretKey correctly', () {
      expect(keyStore.secretKey, secretKey);
    });

    test('sets mnemonic to null', () {
      expect(keyStore.mnemonic, null);
    });
  });

  group('compare keystore', () {
    test('is equals', () {
      final k1 = KeyStore.fromSecretKey('pouet');
      final k2 = KeyStore.fromSecretKey('pouet');
      expect(k1, k2);
    });
    test('is not equals', () {
      final k1 = KeyStore.fromSecretKey('pouet');
      final k2 = KeyStore.fromSecretKey('yeaahh');
      expect(k1, isNot(k2));
    });
  });

  group('getters', () {
    KeyStore keyStore;
    setUp(() {
      const secretKey = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';

      keyStore = KeyStore.fromSecretKey(secretKey);
    });
    test('#publicKey computes the publicKey correctly', () {
      expect(keyStore.publicKey, 'edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU');
    });

    test('#address computes correctly', () {
      expect(keyStore.address, 'tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW');
    });

    group('#edsk', () {
      String secretKey;

      group('when the secretKey is edsk2 format', () {
        setUp(() {
          secretKey = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';
          keyStore = KeyStore.fromSecretKey(secretKey);
        });

        test('returns valid edsk format', () {
          expect(keyStore.edsk,
              'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap');
        });
      });

      group('when the secretKey is edsk format', () {
        setUp(() {
          secretKey =
              'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';
          keyStore = KeyStore.fromSecretKey(secretKey);
        });

        test('returns secretKey', () {
          expect(keyStore.edsk, secretKey);
        });
      });
    });
  });

  group('signature methods', () {
    final keystore = KeyStore.fromMnemonic(mnemonic);

    group('.signBytes', () {
      final bytes = Uint8List.fromList([123, 78, 19]);
      final subject = keystore.signBytes(bytes);

      test('it returns a valid signature', () {
        final result = subject;
        final expectedResult = Signature.fromBytes(bytes: bytes, keyStore: keystore);

        expect(result, equals(expectedResult));
      });
    });

    group('.signHex', () {
      final hex = '5483953ab23b';
      final subject = keystore.signHex(hex);

      test('it returns a valid signature', () {
        final result = subject;
        final expectedResult = Signature.fromHex(data: hex, keyStore: keystore);

        expect(result, equals(expectedResult));
      });
    });
  });
}
