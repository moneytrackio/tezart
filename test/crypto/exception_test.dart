import 'package:test/test.dart';
import 'package:tezart/src/crypto/exception.dart';

final someErrorMsg = 'some fake message';

int sampleWithException(final value) {
  if (value == 0) {
    throw CryptoError(errorCode: 1, message: someErrorMsg);
  }
  return value;
}

void main() {
  test("Crypto Exception is throw", () {
    final exceptedError = 'CryptoError: got code 1 with msg $someErrorMsg.';
    expect(
        () => sampleWithException(0),
        throwsA(predicate(
          (e) =>
              e is CryptoError &&
              e.message == someErrorMsg &&
              e.toString() == exceptedError,
        )));
  });

  test("Crypto Exception is not throw", () {
    expect(sampleWithException(1), 1);
  });
}
