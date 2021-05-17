import 'micheline_encoder.dart';

class OptionEncoder implements MichelineEncoder {
  @override
  final dynamic? params;
  @override
  final Map<String, dynamic> type;

  OptionEncoder({required this.params, required this.type});

  @override
  Map<String, dynamic> encode() {
    if (params == null) return {'prim': 'None'};

    return {
      'prim': 'Some',
      'args': [
        MichelineEncoder(type: type['args'].first, params: params).encode(),
      ]
    };
  }
}
