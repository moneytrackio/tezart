import 'micheline_decoder_factory.dart';

class MichelineDecoder {
  final Map<String, dynamic> type;
  final data;

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
