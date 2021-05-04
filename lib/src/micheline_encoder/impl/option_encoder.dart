import 'micheline_encoder.dart';

class OptionEncoder implements MichelineEncoder {
  @override
  final dynamic? params;
  @override
  final Map<String, dynamic> schema;

  OptionEncoder({required this.params, required this.schema});

  @override
  Map<String, dynamic> encode() {
    if (params == null) return {'prim': 'None'};

    return {
      'prim': 'Some',
      'args': [
        MichelineEncoder(schema: schema['args'].first, params: params).encode(),
      ]
    };
  }
}
