import 'package:tezart/src/contracts/contract.dart';

import 'micheline_decoder.dart';

class BigMapDecoder implements MichelineDecoder {
  @override
  final Map<String, dynamic> schema;
  @override
  final Map<String, dynamic> data;
  final String? annot;

  BigMapDecoder({required this.annot, required this.schema, required this.data});

  @override
  BigMap decode() {
    return BigMap(
      name: annot,
      id: data['int'],
      keyType: schema['args'].first,
      valueType: schema['args'][1],
    );
  }
}
