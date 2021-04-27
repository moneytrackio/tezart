import 'micheline_encoder.dart';

class PairEncoder implements MichelineEncoder {
  @override
  final Map<String, dynamic> params;
  @override
  final Map<String, dynamic> schema;

  PairEncoder({required this.params, required this.schema});

  @override
  Map<String, dynamic> encode() {
    return {
      'prim': 'Pair',
      'args': [
        MichelineEncoder(
          schema: schema['args'].first,
          params: _firstParams,
        ).encode(),
        MichelineEncoder(
          schema: schema['args'][1],
          params: _secondParams,
        ).encode(),
      ]
    };
  }

  dynamic get _firstParams {
    return params;
  }

  dynamic get _secondParams {
    return params;
    // if (params.length > 2) return params.skip(1).toList();

    // return params[1];
  }
}
