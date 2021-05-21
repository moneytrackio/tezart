import 'bytes_encoder.dart';
import 'int_encoder.dart';
import 'list_encoder.dart';
import 'map_encoder.dart';
import 'option_encoder.dart';
import 'pair_encoder.dart';
import 'string_encoder.dart';
import 'timestamp_encoder.dart';
import 'unit_encoder.dart';

/// A class that converts Dart type object to Micheline
///
/// [type] is a Map defining the type of the data we want to convert
/// [params] the data we want to convert
class MichelineEncoder {
  final Map<String, dynamic> type;
  final dynamic params;

  MichelineEncoder({required this.type, required this.params});

  // might be Map<String,dynamic> in the general case but also List in the case of prim == 'list'
  dynamic encode() {
    final prim = type['prim'];
    MichelineEncoder encoder;

    switch (prim) {
      case 'pair':
        encoder = PairEncoder(params: _params, type: type);
        break;
      case 'timestamp':
        encoder = TimestampEncoder(_params);
        break;
      case 'string':
      // TODO: implement validators of these types
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
        encoder = OptionEncoder(params: _params, type: type);
        break;
      case 'list':
        encoder = ListEncoder(params: _params, type: type);
        break;
      case 'map':
      case 'big_map':
        encoder = MapEncoder(params: _params, type: type);
        break;
      case 'unit':
        encoder = UnitEncoder();
        break;
      default:
        throw UnimplementedError('Unknown type : $prim');
    }

    return encoder.encode();
  }

  bool get _isAnonymous {
    return !(type.containsKey('annots') && type['annots'] != null);
  }

  dynamic get _params {
    return _isAnonymous ? params : (params as Map<String, dynamic>)[_annot];
  }

  String? get _annot {
    if (_isAnonymous) return null;

    return (type['annots'].first as String).substring(1);
  }
}
