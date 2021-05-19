import 'micheline_decoder.dart';

class OptionDecoder implements MichelineDecoder {
  @override
  final dynamic data;
  @override
  final Map<String, dynamic> type;

  OptionDecoder({required this.data, required this.type});

  @override
  dynamic decode() {
    if (data['prim'] == 'None') return null;

    return MichelineDecoder(type: type['args'].first, data: data['args'].first).decode();
  }
}
