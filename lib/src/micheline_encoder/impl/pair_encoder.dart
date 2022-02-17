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
    return {'prim': 'Pair', 'args': _args};
  }

  List<dynamic> get _args {
    List type_args = type['args'];
    final args_iterator = type_args.asMap().entries.map((entry) {
      var idx = entry.key;
      dynamic type_arg = entry.value;

      return (MichelineEncoder(
        type: type_arg,
        params: _paramN(idx),
      ).encode());
    });
    return args_iterator.toList();
  }

  int get _argsCount {
    return (type['args'].length);
  }

  dynamic _paramN(int n) {
    if (params is Map) return params;
    if (params is List) {
      var isLastArg = (n == type['args'].length - 1);
      // Handle the case when last arg is i Pair, which arguments are the last elements of the data
      if (isLastArg && params.length > _argsCount) {
        return params.skip(_argsCount - 1).toList();
      } else {
        return params[n];
      }
    }
    throw TypeError();
  }
}
