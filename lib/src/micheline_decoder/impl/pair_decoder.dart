import 'package:quiver/iterables.dart';

import 'micheline_decoder.dart';

class PairDecoder implements MichelineDecoder {
  @override
  final Map<String, dynamic> type;
  @override
  final dynamic data;

  PairDecoder({required this.type, required this.data});

  @override
  Map<String, dynamic> decode() {
    return zip<dynamic>(
      [data['args'].toList(), type['args'].toList()],
    ).map((zippedElement) {
      final currentData = zippedElement.first;
      final currentType = zippedElement[1];

      return MichelineDecoder(data: currentData, type: currentType).decode();
    }).fold<Map<String, dynamic>>({}, (previousValue, element) => {...previousValue, ...element});
  }
}
