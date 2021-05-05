import 'address_decoder.dart';
import 'big_map_decoder.dart';
import 'bytes_decoder.dart';
import 'int_decoder.dart';
import 'key_decoder.dart';
import 'list_decoder.dart';
import 'map_decoder.dart';
import 'option_decoder.dart';
import 'pair_decoder.dart';
import 'signature_decoder.dart';
import 'string_decoder.dart';
import 'timestamp_decoder.dart';

class MichelineDecoder {
  final Map<String, dynamic> schema;
  final data;

  MichelineDecoder({required this.schema, required this.data});

  dynamic decode() {
    final prim = schema['prim'];
    MichelineDecoder decoder;

    switch (prim) {
      case 'pair':
        decoder = PairDecoder(schema: schema, data: data);
        break;
      case 'string':
        decoder = StringDecoder(data);
        break;
      case 'list':
        decoder = ListDecoder(schema: schema, data: data);
        break;
      case 'map':
        decoder = MapDecoder(data: data, schema: schema);
        break;
      case 'big_map':
        decoder = BigMapDecoder(annot: _annot, schema: schema, data: data);
        break;
      case 'bytes':
        decoder = BytesDecoder(data);
        break;
      case 'int':
      case 'nat':
        decoder = IntDecoder(data);
        break;
      case 'key':
        decoder = KeyDecoder(data);
        break;
      case 'timestamp':
        decoder = TimestampDecoder(data);
        break;
      case 'address':
        decoder = AddressDecoder(data);
        break;
      case 'option':
        decoder = OptionDecoder(data: data, schema: schema);
        break;
      case 'signature':
        decoder = SignatureDecoder(data);
        break;
      default:
        throw UnimplementedError('Unknwon type: $prim');
    }

    final decodedValue = decoder.decode();

    return _isAnonymous ? decodedValue : {_annot: decodedValue};
  }

  // TODO: duplicated code, refactor this
  bool get _isAnonymous {
    return !(schema.containsKey('annots') && schema['annots'] != null);
  }

  String get _annot {
    return (schema['annots'].first as String).substring(1);
  }
}
