import 'micheline_decoder.dart';

class BytesDecoder implements MichelineDecoder {
  @override
  final type = {};
  @override
  final Map<String, dynamic> data;

  BytesDecoder(this.data);

  @override
  String decode() {
    return data['bytes'] ?? data['string'];
  }
}
