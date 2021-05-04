import 'micheline_encoder.dart';

class ListEncoder implements MichelineEncoder {
  @override
  final List params;
  @override
  final Map<String, dynamic> schema;

  ListEncoder({required this.params, required this.schema});

  @override
  List encode() {
    return params.map((element) => MichelineEncoder(schema: schema['args'].first, params: element).encode()).toList();
  }
}
