import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tezart/keystore.dart';
import 'package:collection/collection.dart';

Function eq = const ListEquality().equals;

void main() {
  const mnemonic =
      'brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';

  group('keyPair generation :', () {
    test('keyPairFromMnemonic() returns from mnemonic', () {
      final expectedPk = [
        213,
        230,
        70,
        201,
        145,
        25,
        199,
        113,
        66,
        143,
        204,
        81,
        200,
        181,
        129,
        180,
        128,
        238,
        115,
        144,
        203,
        242,
        196,
        207,
        52,
        71,
        189,
        51,
        172,
        119,
        168,
        78
      ]; //
      final expectedSk = [
        98,
        205,
        166,
        170,
        210,
        8,
        237,
        237,
        195,
        178,
        37,
        31,
        210,
        237,
        240,
        73,
        87,
        247,
        165,
        70,
        0,
        137,
        133,
        110,
        21,
        130,
        35,
        21,
        173,
        194,
        215,
        96
      ];

      //
      final keyPair = KeyStore.keyPairFromMnemonic(mnemonic);
      expect(eq(keyPair.pk.toList(), expectedPk), true);
      expect(eq(keyPair.sk.toList(), expectedSk), true);
    });

    test('keyPairFromSeed() returns from seed', () {
      final expectedPk = [
        121,
        181,
        86,
        46,
        143,
        230,
        84,
        249,
        64,
        120,
        177,
        18,
        232,
        169,
        139,
        167,
        144,
        31,
        133,
        58,
        230,
        149,
        190,
        215,
        224,
        227,
        145,
        11,
        173,
        4,
        150,
        100
      ];
      final expectedSk = [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        121,
        181,
        86,
        46,
        143,
        230,
        84,
        249,
        64,
        120,
        177,
        18,
        232,
        169,
        139,
        167,
        144,
        31,
        133,
        58,
        230,
        149,
        190,
        215,
        224,
        227,
        145,
        11,
        173,
        4,
        150,
        100
      ];
      final values = List<int>.generate(32, (index) => index + 1);
      final keyPair = KeyStore.keyPairFromSeed(Uint8List.fromList(values));

      //
      expect(eq(keyPair.pk.toList(), expectedPk), true);
      expect(eq(keyPair.sk.toList(), expectedSk), true);
    });
  });
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
      expect(keyStore.secretKey,
          'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa');
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
      const secretKey =
          'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';

      keyStore = KeyStore.fromSecretKey(secretKey);
    });
    test('#publicKey computes the publicKey correctly', () {
      expect(keyStore.publicKey,
          'edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU');
    });

    test('#address computes correctly', () {
      expect(keyStore.address, 'tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW');
    });

    test('#edsk computes correctly', () {
      //TODO
    });
  });
}
