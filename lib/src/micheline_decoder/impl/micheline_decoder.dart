import 'micheline_decoder_factory.dart';

class MichelineDecoder {
  final Map<String, dynamic> schema;
  final data;

  MichelineDecoder({required this.schema, required this.data});

  dynamic decode() {
    final prim = schema['prim'];
    final decodedValue = MichelineDecoderFactory.decoderFor(
      prim: prim,
      schema: schema,
      data: data,
      annot: _annot,
    ).decode();

    return _isAnonymous ? decodedValue : {_annot: decodedValue};
  }

  // TODO: duplicated code, refactor this
  bool get _isAnonymous {
    return !(schema.containsKey('annots') && schema['annots'] != null);
  }

  String? get _annot {
    return (schema['annots']?.first as String?)?.substring(1);
  }
}
