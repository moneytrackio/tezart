import 'micheline_encoder.dart';

class TimestampEncoder implements MichelineEncoder {
  @override
  final DateTime params;
  @override
  final type = {};

  TimestampEncoder(this.params);

  @override
  Map<String, dynamic> encode() {
    return {'int': (params.millisecondsSinceEpoch ~/ 1000).toString()};
  }
}
