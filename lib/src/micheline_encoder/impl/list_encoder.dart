import 'micheline_encoder.dart';

class ListEncoder implements MichelineEncoder {
  @override
  final List params;
  @override
  final Map<String, dynamic> type;

  ListEncoder({required this.params, required this.type});

  @override
  List encode() {
    return params.map((element) => MichelineEncoder(type: type['args'].first, params: element).encode()).toList();
  }
}
