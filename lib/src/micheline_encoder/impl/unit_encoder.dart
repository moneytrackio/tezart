import 'package:tezart/src/micheline_encoder/impl/micheline_encoder.dart';

class UnitEncoder implements MichelineEncoder {
  @override
  final params = {};
  @override
  final schema = {};

  @override
  Map<String, String> encode() {
    return {'prim': 'Unit'};
  }
}
