part of 'package:tezart/crypto.dart';

final _prefixes = {
  'tz1': Uint8List.fromList([6, 161, 159]),
  'tz2': Uint8List.fromList([6, 161, 161]),
  'tz3': Uint8List.fromList([6, 161, 164]),
  'KT': Uint8List.fromList([2, 90, 121]),
  'expr': Uint8List.fromList([13, 44, 64, 27]),
  'edpk': Uint8List.fromList([13, 15, 37, 217]),
  'edsk2': Uint8List.fromList([13, 15, 58, 7]),
  'spsk': Uint8List.fromList([17, 162, 224, 201]),
  'p2sk': Uint8List.fromList([16, 81, 238, 189]),
  'sppk': Uint8List.fromList([3, 254, 226, 86]),
  'p2pk': Uint8List.fromList([3, 178, 139, 127]),
  'edsk': Uint8List.fromList([43, 246, 78, 7]),
  'edsig': Uint8List.fromList([9, 245, 205, 134, 18]),
  'spsig1': Uint8List.fromList([13, 115, 101, 19, 63]),
  'p2sig': Uint8List.fromList([54, 240, 44, 52]),
  'sig': Uint8List.fromList([4, 130, 43]),
  'Net': Uint8List.fromList([87, 82, 0]),
  'nce': Uint8List.fromList([69, 220, 169]),
  'b': Uint8List.fromList([1, 52]),
  'o': Uint8List.fromList([5, 116]),
  'Lo': Uint8List.fromList([133, 233]),
  'LLo': Uint8List.fromList([29, 159, 109]),
  'P': Uint8List.fromList([2, 170]),
  'Co': Uint8List.fromList([79, 179]),
  'id': Uint8List.fromList([153, 103])
};

String _encodeBase58(Uint8List payload) => bs58check.encode(payload);
Uint8List _decodeBase58(String string) => bs58check.decode(string);
Uint8List _hexPrefix(String prefix) {
  final hexPrefix = _prefixes[prefix];
  if (hexPrefix == null)
    throw CryptoError(errorCode: 1, message: 'prefix not found');

  return _prefixes[prefix];
}

Uint8List _ignorePrefix(Uint8List bytes) {
  for (final prefix in _prefixes.keys) {
    final hexPrefix = _hexPrefix(prefix);

    if (ListEquality().equals(bytes.sublist(0, hexPrefix.length), hexPrefix))
      return bytes.sublist(hexPrefix.length);
  }
  throw CryptoError(errorCode: 2, message: "Can\'t ignore an unknown prefix");
}

String encodeTz({@required String prefix, @required Uint8List bytes}) {
  final prefixed = Uint8List.fromList(_hexPrefix(prefix) + bytes);

  return _encodeBase58(prefixed);
}

Uint8List decodeTz(String str) {
  final decoded = _decodeBase58(str);

  return _ignorePrefix(decoded);
}
