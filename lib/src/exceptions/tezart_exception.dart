/// Exception thrown when an error occurs during crypto operation.
abstract class _TezartExceptionI implements Exception {
  String get key;
  String get message;
  dynamic get originalException;
}

abstract class TezartException implements _TezartExceptionI {
  @override
  String toString() {
    return '$runtimeType: got code $key with msg $message.';
  }
}
