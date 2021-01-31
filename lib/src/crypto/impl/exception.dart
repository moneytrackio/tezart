import 'package:meta/meta.dart';

/// Exception thrown when an error occurs during crypto operation.
class CryptoError implements Exception {
  final int errorCode;
  final String message;

  const CryptoError({@required this.errorCode, @required this.message});

  @override
  String toString() {
    return 'CryptoError: got code $errorCode with msg $message.';
  }
}