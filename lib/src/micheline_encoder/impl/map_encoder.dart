import 'micheline_encoder.dart';

class MapEncoder implements MichelineEncoder {
  @override
  final Map<String, dynamic> params;
  @override
  final Map<String, dynamic> type;

  MapEncoder({required this.params, required this.type});

  @override
  List<Map<String, dynamic>> encode() {
    return params.keys
        .map((key) => {
              'prim': 'Elt',
              'args': [
                MichelineEncoder(type: _keyType, params: key).encode(),
                MichelineEncoder(type: _valueType, params: params[key]).encode(),
              ],
            })
        .toList();
  }

  Map<String, dynamic> get _keyType => type['args'].first;
  Map<String, dynamic> get _valueType => type['args'][1];
}
