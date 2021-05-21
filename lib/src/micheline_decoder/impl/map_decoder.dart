import 'micheline_decoder.dart';

class MapDecoder implements MichelineDecoder {
  @override
  final List data;
  @override
  final Map<String, dynamic> type;

  MapDecoder({required this.data, required this.type});

  @override
  Map<String, dynamic> decode() {
    return data.fold({}, (previousValue, element) {
      final key = MichelineDecoder(
        type: type['args'].first,
        data: element['args'].first,
      ).decode();
      final value = MichelineDecoder(
        type: type['args'][1],
        data: element['args'][1],
      ).decode();

      return {...previousValue, key: value};
    });
  }
}
