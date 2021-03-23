import 'package:pointycastle/export.dart';
import 'package:meta/meta.dart';
import 'dart:typed_data';

Uint8List deriveBits({
  @required Uint8List passphrase,
  @required Uint8List salt,
  @required int iterationCount,
  @required int keyLength,
}) {
  final target = Uint8List(keyLength);
  final params = Pbkdf2Parameters(salt, iterationCount, keyLength);
  final derivator = PBKDF2KeyDerivator((HMac(SHA512Digest(), keyLength)));

  derivator.init(params);
  derivator.deriveKey(passphrase, 0, target, 0);

  return target;
}
