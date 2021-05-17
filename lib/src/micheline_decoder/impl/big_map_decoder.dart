import 'package:tezart/src/contracts/contract.dart';

import 'micheline_decoder.dart';

class BigMapDecoder implements MichelineDecoder {
  @override
  final Map<String, dynamic> type;
  @override
  final Map<String, dynamic> data;
  final String? annot;

  BigMapDecoder({required this.annot, required this.type, required this.data});

  @override
  BigMap decode() {
    return BigMap(
      name: annot,
      id: data['int'],
      keyType: type['args'].first,
      valueType: type['args'][1],
    );
  }
}
