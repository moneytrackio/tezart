import 'dart:typed_data';
import 'package:convert/convert.dart' show hex;
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

import 'crypto_error.dart';
import 'prefixes.dart';

final _prefixesToBytes = {
  Prefixes.tz1: Uint8List.fromList([6, 161, 159]),
  Prefixes.tz2: Uint8List.fromList([6, 161, 161]),
  Prefixes.tz3: Uint8List.fromList([6, 161, 164]),
  Prefixes.KT: Uint8List.fromList([2, 90, 121]),
  Prefixes.expr: Uint8List.fromList([13, 44, 64, 27]),
  Prefixes.edpk: Uint8List.fromList([13, 15, 37, 217]),
  Prefixes.edsk2: Uint8List.fromList([13, 15, 58, 7]),
  Prefixes.spsk: Uint8List.fromList([17, 162, 224, 201]),
  Prefixes.p2sk: Uint8List.fromList([16, 81, 238, 189]),
  Prefixes.sppk: Uint8List.fromList([3, 254, 226, 86]),
  Prefixes.p2pk: Uint8List.fromList([3, 178, 139, 127]),
  Prefixes.edsk: Uint8List.fromList([43, 246, 78, 7]),
  Prefixes.edesk: Uint8List.fromList([7, 90, 60, 179, 41]),
  Prefixes.edsig: Uint8List.fromList([9, 245, 205, 134, 18]),
  Prefixes.spsig1: Uint8List.fromList([13, 115, 101, 19, 63]),
  Prefixes.p2sig: Uint8List.fromList([54, 240, 44, 52]),
  Prefixes.sig: Uint8List.fromList([4, 130, 43]),
  Prefixes.Net: Uint8List.fromList([87, 82, 0]),
  Prefixes.nce: Uint8List.fromList([69, 220, 169]),
  Prefixes.b: Uint8List.fromList([1, 52]),
  Prefixes.o: Uint8List.fromList([5, 116]),
  Prefixes.Lo: Uint8List.fromList([133, 233]),
  Prefixes.LLo: Uint8List.fromList([29, 159, 109]),
  Prefixes.P: Uint8List.fromList([2, 170]),
  Prefixes.Co: Uint8List.fromList([79, 179]),
  Prefixes.id: Uint8List.fromList([153, 103])
};

String _encodeBase58(Uint8List payload) => bs58check.encode(payload);
Uint8List _decodeBase58(String string) => bs58check.decode(string);
bool isChecksumValid(String string) {
  try {
    _decodeBase58(string);
    return true;
  } on ArgumentError catch (e) {
    if (e.message == 'Invalid checksum') return false;

    rethrow;
  }
}

Uint8List hexDecode(String encoded) => Uint8List.fromList(hex.decode(encoded));
String hexEncode(Uint8List input) => hex.encode(input.toList());

@visibleForTesting
Uint8List prefixBytes(Prefixes prefix) {
  final prefixBytes = _prefixesToBytes[prefix];
  if (prefixBytes == null) {
    throw CryptoError(type: CryptoErrorTypes.prefixNotFound);
  }

  return _prefixesToBytes[prefix]!;
}

@visibleForTesting
Uint8List ignorePrefix(Uint8List bytes) {
  for (final currentPrefix in _prefixesToBytes.keys) {
    final currentPrefixBytes = prefixBytes(currentPrefix);

    if (ListEquality().equals(bytes.sublist(0, currentPrefixBytes.length), currentPrefixBytes)) {
      return bytes.sublist(currentPrefixBytes.length);
    }
  }
  throw CryptoError(type: CryptoErrorTypes.prefixNotFound);
}

String encodeWithPrefix({required Prefixes prefix, required Uint8List bytes}) {
  final prefixed = Uint8List.fromList(prefixBytes(prefix) + bytes);

  return _encodeBase58(prefixed);
}

Uint8List decodeWithoutPrefix(String str) {
  final decoded = _decodeBase58(str);

  return ignorePrefix(decoded);
}
