import 'package:memoize/memoize.dart';
import 'package:tezart/src/micheline_encoder/impl/micheline_encoder.dart';

import 'operation.dart';

class OriginationOperation extends Operation {
  OriginationOperation({
    required int balance,
    required List<Map<String, dynamic>> code,
    required dynamic storage, // Dart objects storage
    int? customFee,
  }) : super(
          kind: Kinds.origination,
          balance: balance,
          script: {
            'code': code,
            'storage': _encodedStorage(code, storage),
          },
          customFee: customFee,
        );

  Future<String> get contractAddress async {
    return memo0<Future<String>>(() async {
      if (operationsList == null) throw ArgumentError.notNull('operation.operationsList');

      // TODO: why does the node return a list of originated contracts ?
      return operationsList!
          .operations.first.simulationResult?['metadata']['operation_result']['originated_contracts'].first;
    })();
  }

  static dynamic _encodedStorage(List<Map<String, dynamic>> code, dynamic storage) {
    final schema = code.first['args']?.first;
    if (schema == null) throw ArgumentError.notNull('schema');

    return MichelineEncoder(schema: schema, params: storage).encode();
  }
}
