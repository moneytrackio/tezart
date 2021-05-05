import 'micheline_decoder.dart';

class MapDecoder implements MichelineDecoder {
  @override
  final List data;
  @override
  final Map<String, dynamic> schema;

  MapDecoder({required this.data, required this.schema});

  @override
  Map<String, dynamic> decode() {
    return data.fold({}, (previousValue, element) {
      final key = MichelineDecoder(
        schema: schema['args'].first,
        data: element['args'].first,
      ).decode();
      final value = MichelineDecoder(
        schema: schema['args'][1],
        data: element['args'][1],
      ).decode();

      return {...previousValue, key: value};
    });
  }
}
