import 'micheline_encoder.dart';

class BytesEncoder implements MichelineEncoder {
  @override
  final String params;
  @override
  final type = {};

  BytesEncoder(this.params);

  @override
  Map<String, dynamic> encode() {
    return {'bytes': params};
  }
}
