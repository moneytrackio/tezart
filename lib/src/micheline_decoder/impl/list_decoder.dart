import 'micheline_decoder.dart';

class ListDecoder implements MichelineDecoder {
  @override
  final Map<String, dynamic> type;
  @override
  final List<dynamic> data;

  ListDecoder({required this.type, required this.data});

  @override
  List<dynamic> decode() {
    return data.map((e) {
      return MichelineDecoder(type: type['args'].first, data: e).decode();
    }).toList();
  }
}
