import 'package:tezart/src/crypto/crypto.dart';

import 'micheline_decoder.dart';

class SignatureDecoder implements MichelineDecoder {
  @override
  final type = {};
  @override
  final Map<String, dynamic> data;

  SignatureDecoder(this.data);

  @override
  String decode() {
    if (data.containsKey('bytes')) return encodeWithPrefix(prefix: Prefixes.edsig, bytes: data['bytes']);

    return data['string'];
  }
}
