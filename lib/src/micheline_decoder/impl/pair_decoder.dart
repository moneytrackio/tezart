import 'package:quiver/iterables.dart';

import 'micheline_decoder.dart';

class PairDecoder implements MichelineDecoder {
  @override
  final Map<String, dynamic> schema;
  @override
  final dynamic data;

  PairDecoder({required this.schema, required this.data});

  @override
  Map<String, dynamic> decode() {
    return zip<dynamic>(
      [data['args'].toList(), schema['args'].toList()],
    ).map((zippedElement) {
      final currentData = zippedElement.first;
      final currentSchema = zippedElement[1];

      return MichelineDecoder(data: currentData, schema: currentSchema).decode();
    }).fold<Map<String, dynamic>>({}, (previousValue, element) => {...previousValue, ...element});
  }
}
