import 'micheline_encoder.dart';

class MapEncoder implements MichelineEncoder {
  @override
  final Map<String, dynamic> params;
  @override
  final Map<String, dynamic> schema;

  MapEncoder({required this.params, required this.schema});

  @override
  List<Map<String, dynamic>> encode() {
    return params.keys
        .map((key) => {
              'prim': 'Elt',
              'args': [
                MichelineEncoder(schema: _keySchema, params: key).encode(),
                MichelineEncoder(schema: _valueSchema, params: params[key]).encode(),
              ],
            })
        .toList();
  }

  Map<String, dynamic> get _keySchema => schema['args'].first;
  Map<String, dynamic> get _valueSchema => schema['args'][1];
}
