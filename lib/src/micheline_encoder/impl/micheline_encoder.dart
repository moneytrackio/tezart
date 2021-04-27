import 'bytes_encoder.dart';
import 'int_encoder.dart';
import 'option_encoder.dart';
import 'pair_encoder.dart';
import 'string_encoder.dart';
import 'timestamp_encoder.dart';

class MichelineEncoder {
  final Map<String, dynamic> schema;
  final dynamic params;

  MichelineEncoder({required this.schema, required this.params});

  Map<String, dynamic> encode() {
    final prim = schema['prim'];
    MichelineEncoder encoder;

    switch (prim) {
      case 'pair':
        encoder = PairEncoder(params: _params, schema: schema);
        break;
      case 'timestamp':
        encoder = TimestampEncoder(_params);
        break;
      case 'string':
      case 'address':
      case 'contract':
      case 'key':
      case 'signature':
        encoder = StringEncoder(_params);
        break;
      case 'bytes':
        encoder = BytesEncoder(_params);
        break;
      case 'nat':
      case 'int':
        encoder = IntEncoder(_params);
        break;
      case 'option':
        encoder = OptionEncoder(params: _params, schema: schema);
        break;
      default:
        throw UnimplementedError('Unknown type : $prim');
    }

    return encoder.encode();
  }

  bool get _isAnonymous {
    return !(schema.containsKey('annots') && schema['annots'] != null);
  }

  dynamic get _params {
    return _isAnonymous ? params : params[_annot];
  }

  String? get _annot {
    if (_isAnonymous) return null;

    return (schema['annots'].first as String).substring(1);
  }
}
