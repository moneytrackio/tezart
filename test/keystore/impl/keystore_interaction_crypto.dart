
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tezart/keystore.dart';
import 'package:tezart/src/crypto/crypto_operation.dart';
import '../../utils/crypto_common.dart' as crypto_common;


class MockCryptoOperation extends Mock implements CryptoOperation {}

testInteractionWithCryptoOperation() {
  const mnemonic = "whatever";

  var cryptoOperationMock = MockCryptoOperation();
  when(cryptoOperationMock.generateMnemonic(strength: anyNamed('strength')))
      .thenReturn('valeur_generateMnemonic');
  when(cryptoOperationMock.hashWithDigestSize(
          size: anyNamed('size'), bytes: anyNamed('bytes')))
      .thenReturn(crypto_common.fakeUint8List());
  when(cryptoOperationMock.encodeTz(
          prefix: anyNamed('prefix'), bytes: anyNamed('bytes')))
      .thenReturn('valeur_encodeTz');
  when(cryptoOperationMock.decodeTz('valeur_decodeTz'))
      .thenReturn(crypto_common.fakeUint8List());

  test('.fromMnemonic interaction with crypto', () {
    KeyStore keyStore =
        KeyStore.fromMnemonic(mnemonic, crypto: cryptoOperationMock);
    expect(keyStore.mnemonic, mnemonic);
    // Exact number of invocations
    verify(cryptoOperationMock.encodeTz(
            prefix: anyNamed('prefix'), bytes: anyNamed('bytes')))
        .called(1);

    expect(keyStore.secretKey, 'valeur_encodeTz');

  });

  test('.random interaction with crypto', () {
    KeyStore keyStore = KeyStore.random(crypto: cryptoOperationMock);

    // Exact number of invocations
    verify(cryptoOperationMock.generateMnemonic(strength: anyNamed('strength')))
        .called(1);

    expect(keyStore.mnemonic, 'valeur_generateMnemonic');
  });
}
