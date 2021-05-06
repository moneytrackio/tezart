import 'micheline_decoder.dart';

class BytesDecoder implements MichelineDecoder {
  @override
  final schema = {};
  @override
  final Map<String, dynamic> data;

  BytesDecoder(this.data);

  @override
  String decode() {
    return data['bytes'] ?? data['string'];
  }
}
