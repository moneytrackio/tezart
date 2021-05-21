import 'micheline_decoder.dart';

class TimestampDecoder implements MichelineDecoder {
  @override
  final Map<String, dynamic> data;
  @override
  final type = {};

  TimestampDecoder(this.data);

  @override
  DateTime decode() {
    dynamic timestamp = data['int'] ?? data['string'];

    if (timestamp is String && RegExp(r'^\d+$').hasMatch(timestamp)) timestamp = int.parse(timestamp);
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    }

    return DateTime.parse(timestamp);
  }
}
