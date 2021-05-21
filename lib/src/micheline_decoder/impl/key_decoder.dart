import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:tezart/src/crypto/crypto.dart';

import 'micheline_decoder.dart';

class KeyDecoder implements MichelineDecoder {
  @override
  final type = {};
  @override
  final Map<String, dynamic> data;

  KeyDecoder(this.data);

  @override
  String decode() {
    if (data.containsKey('bytes')) {
      final String stringBytes = data['bytes'];
      final bytes = Uint8List.fromList(hex.decode(stringBytes.substring(2)));
      Prefixes? prefix;

      if (stringBytes.startsWith('00')) {
        prefix = Prefixes.edpk;
      } else if (stringBytes.startsWith('01')) {
        prefix = Prefixes.sppk;
      } else if (stringBytes.startsWith('02')) {
        prefix = Prefixes.p2pk;
      }

      return prefix != null ? encodeWithPrefix(prefix: prefix, bytes: bytes) : data['bytes'];
    }

    return data['string'];
  }
}
