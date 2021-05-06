import 'micheline_decoder.dart';

class OptionDecoder implements MichelineDecoder {
  @override
  final dynamic data;
  @override
  final Map<String, dynamic> schema;

  OptionDecoder({required this.data, required this.schema});

  @override
  dynamic decode() {
    if (data['prim'] == 'None') return null;

    return MichelineDecoder(schema: schema['args'].first, data: data['args'].first).decode();
  }
}
