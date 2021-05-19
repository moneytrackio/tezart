import 'address_decoder.dart';
import 'big_map_decoder.dart';
import 'bytes_decoder.dart';
import 'int_decoder.dart';
import 'key_decoder.dart';
import 'list_decoder.dart';
import 'map_decoder.dart';
import 'micheline_decoder.dart';
import 'option_decoder.dart';
import 'pair_decoder.dart';
import 'signature_decoder.dart';
import 'string_decoder.dart';
import 'timestamp_decoder.dart';
import 'unit_decoder.dart';

class MichelineDecoderFactory {
  static MichelineDecoder decoderFor({
    required String prim,
    required Map<String, dynamic> schema,
    required dynamic data,
    required String? annot,
  }) {
    switch (prim) {
      case 'pair':
        return PairDecoder(schema: schema, data: data);
      case 'string':
        // cast to fix : _TypeError (type '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'Map<String, String>')
        return StringDecoder(Map<String, String>.from(data));
      case 'list':
        return ListDecoder(schema: schema, data: data);
      case 'map':
        return MapDecoder(data: data, schema: schema);
      case 'big_map':
        return BigMapDecoder(annot: annot, schema: schema, data: data);
      case 'bytes':
        return BytesDecoder(data);
      case 'int':
      case 'nat':
        return IntDecoder(data);
      case 'key':
        return KeyDecoder(data);
      case 'timestamp':
        return TimestampDecoder(data);
      case 'address':
        return AddressDecoder(data);
      case 'option':
        return OptionDecoder(data: data, schema: schema);
      case 'signature':
        return SignatureDecoder(data);
      case 'unit':
        return UnitDecoder();
      default:
        throw UnimplementedError('Unknwon type: $prim');
    }
  }
}
