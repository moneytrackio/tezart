/// Exception thrown when an error occurs during crypto operation.
abstract class TezartException implements Exception {
  String get key;
  String get message;
  dynamic get originalException;
}
