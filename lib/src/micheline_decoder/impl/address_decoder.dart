import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:tezart/src/crypto/crypto.dart';

import 'micheline_decoder.dart';

class AddressDecoder implements MichelineDecoder {
  @override
  final type = {};
  @override
  final Map<String, dynamic> data;

  AddressDecoder(this.data);

  @override
  String decode() {
    if (data.containsKey('bytes')) {
      final String stringBytes = data['bytes'];
      final bytes = Uint8List.fromList(hex.decode(stringBytes.substring(4)));
      Prefixes? prefix;

      if (stringBytes.startsWith('0000')) {
        prefix = Prefixes.tz1;
      } else if (stringBytes.startsWith('0001')) {
        prefix = Prefixes.tz2;
      } else if (stringBytes.startsWith('0002')) {
        prefix = Prefixes.tz3;
      } else if (stringBytes.startsWith('01')) prefix = Prefixes.KT;

      return prefix == null ? data['bytes'] : encodeWithPrefix(prefix: prefix, bytes: bytes);
    }

    return data['string'];
  }
}
