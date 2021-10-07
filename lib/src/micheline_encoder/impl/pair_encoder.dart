import 'micheline_encoder.dart';

class PairEncoder implements MichelineEncoder {
  @override
  // Might be a Map<String, dynamic> or List<dynamic>
  final dynamic params;
  @override
  final Map<String, dynamic> type;

  PairEncoder({required this.params, required this.type});

  @override
  Map<String, dynamic> encode() {
    return {
      'prim': 'Pair',
      'args': [
        MichelineEncoder(
          type: type['args'].first,
          params: _firstParams,
        ).encode(),
        MichelineEncoder(
          type: type['args'][1],
          params: _secondParams,
        ).encode(),
      ]
    };
  }

  dynamic get _firstParams {
    if (params is Map) return params;
    if (params is List) return params.first;

    throw TypeError();
  }

  dynamic get _secondParams {
    if (params is Map) return params;
    if (params is List) {
      if (params.length > 2) return params.skip(1).toList();

      return params.length == 2 ? params[1] : null;
    }
    throw TypeError();
  }
}
