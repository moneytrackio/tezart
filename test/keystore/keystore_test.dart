// ignore_for_file: prefer_function_declarations_over_variables

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
    group('when the mnemonic is valid', () {
      group('when the mnemonic is not encrypted by email/password', () {
        final subject = () => Keystore.fromMnemonic(mnemonic);

        test('sets mnemonic correctly', () {
          expect(subject().mnemonic, mnemonic);
        });

        test('computes secretKey correctly', () {
          expect(subject().secretKey,
              'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap');
        });
      });

      group('when the mnemonic is encrypted by email/password', () {
        final subject = () => Keystore.fromMnemonic(mnemonic, password: 'password', email: 'email@example.com');

        test('it sets mnemonic correctly', () {
          expect(subject().mnemonic, mnemonic);
        });

        test('it sets secret key correctly', () {
          const secretKey =
              'edskS3jw3crpqkhuJZAuJMFLB4ZDvXGcm5nEWfgypk6gSyg17ZCnDbVLHupxNTUUrrQLiakgvcjsi4vNyduzyWaVUX5LHXE8Bf';
          expect(subject().secretKey, secretKey);
        });
      });
    });

    group('when the mnemonic is invalid', () {
      final subject = (String mnemonic) => Keystore.fromMnemonic(mnemonic);
      group('when the mnemonic is short', () {
        const mnemonic = 'brief hello';

        test('it throws an error', () {
          expect(() => subject(mnemonic),
              throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.invalidMnemonic)));
        });
      });

      group('when the mnemonic contains an unknown word', () {
        const mnemonic =
            'toto hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';

        test('it throws an error', () {
          expect(() => subject(mnemonic),
              throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.invalidMnemonic)));
        });
      });
    });
  });

  group('.fromSecretKey', () {
    final subject = (String secretKey) => Keystore.fromSecretKey(secretKey);

    group('when the secret key is valid', () {
      final secretKey =
          'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';

      test('sets secretKey correctly', () {
        expect(subject(secretKey).secretKey, secretKey);
      });

      test('sets mnemonic to null', () {
        expect(subject(secretKey).mnemonic, null);
      });

      test('it computes the seed correctly', () {
        expect(subject(secretKey).seed, 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa');
      });
    });

    group('when the secret key has invalid checksum', () {
      final secretKey =
          'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkaa';

      test('it throws an error', () {
        expect(() => subject(secretKey),
            throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.invalidChecksum)));
      });
    });

    group('when the input is a seed', () {
      final secretKey = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';

      test('throws an error', () {
        expect(() => subject(secretKey),
            throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.secretKeyLengthError)));
      });
    });
  });

  group('.fromSeed', () {
    final subject = (String seed) => Keystore.fromSeed(seed);

    group('when the seed is valid', () {
      final secretKey =
          'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';
      final seed = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';

      test('sets secretKey correctly', () {
        expect(subject(seed).secretKey, secretKey);
      });

      test('sets mnemonic to null', () {
        expect(subject(seed).mnemonic, null);
      });

      test('it computes the seed correctly', () {
        expect(subject(seed).seed, seed);
      });
    });

    group('when the input is a secret key', () {
      final seed = 'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';

      test('throws an error', () {
        expect(() => subject(seed),
            throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.seedLengthError)));
      });
    });

    group('when the seed has invalid checksum', () {
      final seed = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsb';

      test('it throws an error', () {
        expect(() => subject(seed),
            throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.invalidChecksum)));
      });
    });
  });

  group('.fromEncryptedSecretKey', () {
    final encryptedSecretKey =
        'edesk1RxJkKzwYCcSz4hFy7FiQTPFB6otnmedkjU5REc3bYcpJ3fK6QpaJ1q8Dc8WnWpRKdoaoUjSJ4D4Aa8kLCp';
    final decryptedSecretKey =
        'edskRczqu5WF9zZ2Pm1zAx7s5tfoBBW8t4S8BHRhixggUzSptxAaURSdiNmsE9UMEierbzSPSBshKc7XP4N8eHTaamPrPoq4dz';
    final passphrase = 'passphrase';

    group('when encryptedSecretKey and passphrase are valid', () {
      test('sets secretKey correctly', () {
        final subject = () => Keystore.fromEncryptedSecretKey(encryptedSecretKey, passphrase);

        final keystore = subject();

        expect(keystore.secretKey, decryptedSecretKey);
      });
    });

    group('when encryptedSecretKey length is invalid', () {
      test('throws encryptedSecretKeyLengthError error', () {
        final truncatedEncryptedSecretKey = encryptedSecretKey.substring(0, encryptedSecretKey.length - 1);
        final subject = () => Keystore.fromEncryptedSecretKey(truncatedEncryptedSecretKey, passphrase);

        expect(() => subject(),
            throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.encryptedSecretKeyLengthError)));
      });
    });

    group('when passphrase is invalid', () {
      test('throws CryptoError of type unhandled', () {
        final truncatedPassphrase = passphrase.substring(0, passphrase.length - 1);
        final subject = () => Keystore.fromEncryptedSecretKey(encryptedSecretKey, truncatedPassphrase);

        expect(() => subject(), throwsA(predicate((e) => e is CryptoError && e.type == CryptoErrorTypes.unhandled)));
      });

      test('throws CryptoError with the correct errorMessage', () {
        final truncatedPassphrase = passphrase.substring(0, passphrase.length - 1);
        final errorMessage = 'Unhandled error: The message is forged or malformed or the shared secret is invalid';
        final subject = () => Keystore.fromEncryptedSecretKey(encryptedSecretKey, truncatedPassphrase);

        expect(() => subject(), throwsA(predicate((e) => e is CryptoError && e.message == errorMessage)));
      });
    });
  });

  group('compare keystore', () {
    test('is equals', () {
      final secretKey =
          'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';
      final k1 = Keystore.fromSecretKey(secretKey);
      final k2 = Keystore.fromSecretKey(secretKey);
      expect(k1, k2);
    });

    test('is not equals', () {
      final sk1 = 'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';
      final sk2 = 'edskRudFGJdUnDQUMycDYch2ve7tDbEmQbjc9o8bfg5EJWQkWjPrbeQLSTXhimdVDU4cCSgwuZmmBzVgvuZLoywxx7wmHt8BWQ';
      final k1 = Keystore.fromSecretKey(sk1);
      final k2 = Keystore.fromSecretKey(sk2);
      expect(k1, isNot(k2));
    });
  });

  group('getters', () {
    late Keystore keystore;

    setUp(() {
      const secretKey =
          'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';

      keystore = Keystore.fromSecretKey(secretKey);
    });

    test('#publicKey computes the publicKey correctly', () {
      expect(keystore.publicKey, 'edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU');
    });

    test('#address computes correctly', () {
      expect(keystore.address, 'tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW');
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
