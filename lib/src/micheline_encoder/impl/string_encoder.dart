import 'micheline_encoder.dart';

class StringEncoder implements MichelineEncoder {
  @override
  final String params;
  @override
  final type = {};

  StringEncoder(this.params);

  @override
  Map<String, dynamic> encode() {
    return {'string': params};
  }
}
