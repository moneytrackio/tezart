// internal Library
import 'package:tezart/crypto.dart' as crypto;

import 'dart:typed_data';
import 'package:meta/meta.dart';

class CryptoOperation {
  static final CryptoOperation _singleton = CryptoOperation._internal();

  factory CryptoOperation() {
    return _singleton;
  }

  const CryptoOperation._internal();

  String encodeTz({@required String prefix, @required Uint8List bytes}) =>
      crypto.encodeTz(prefix: prefix, bytes: bytes);

  Uint8List decodeTz(String str) => crypto.decodeTz(str);

  String generateMnemonic({int strength = 256}) =>
      crypto.generateMnemonic(strength: strength);

  Uint8List hashWithDigestSize({@required int size, Uint8List bytes}) =>
      crypto.hashWithDigestSize(size: size, bytes: bytes);
}
