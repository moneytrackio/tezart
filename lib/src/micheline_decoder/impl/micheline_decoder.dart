import 'micheline_decoder_factory.dart';

/// A class that converts Micheline to Dart types
///
/// [type] is a Map defining the type of the data we want to convert
/// [data] the Micheline data we want to convert
class MichelineDecoder {
  final Map<String, dynamic> type;
  final dynamic data;

  MichelineDecoder({required this.type, required this.data});

  dynamic decode() {
    final prim = type['prim'];
    final decodedValue = MichelineDecoderFactory.decoderFor(
      prim: prim,
      type: type,
      data: data,
      annot: _annot,
    ).decode();

    return _isAnonymous ? decodedValue : {_annot: decodedValue};
  }

  // TODO: duplicated code, refactor this
  bool get _isAnonymous {
    return !(type.containsKey('annots') && type['annots'] != null);
  }

  String? get _annot {
    return (type['annots']?.first as String?)?.substring(1);
  }
}
