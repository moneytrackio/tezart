import 'micheline_decoder.dart';

class StringDecoder implements MichelineDecoder {
  @override
  final Map<String, String> data;
  @override
  final Map<String, dynamic> type = {};

  StringDecoder(this.data);

  @override
  String decode() {
    if (data['string'] == null) throw ArgumentError.notNull("data['string']");

    return data['string']!;
  }
}
