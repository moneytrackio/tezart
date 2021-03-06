import 'micheline_decoder.dart';

class IntDecoder implements MichelineDecoder {
  @override
  final type = {};
  @override
  final Map<String, dynamic> data;

  IntDecoder(this.data);

  @override
  int decode() {
    return int.parse(data['int'] as String);
  }
}
