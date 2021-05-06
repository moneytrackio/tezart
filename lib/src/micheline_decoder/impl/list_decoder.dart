import 'micheline_decoder.dart';

class ListDecoder implements MichelineDecoder {
  @override
  final Map<String, dynamic> schema;
  @override
  final List<dynamic> data;

  ListDecoder({required this.schema, required this.data});

  @override
  List<dynamic> decode() {
    return data.map((e) {
      return MichelineDecoder(schema: schema['args'].first, data: e).decode();
    }).toList();
  }
}
