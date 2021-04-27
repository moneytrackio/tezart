import 'micheline_encoder.dart';

class IntEncoder implements MichelineEncoder {
  @override
  final int params;
  @override
  final schema = {};

  IntEncoder(this.params);

  @override
  Map<String, dynamic> encode() {
    return {'int': params.toString()};
  }
}
