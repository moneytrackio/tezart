import 'package:memoize/memoize.dart';

import 'operation.dart';

class OriginationOperation extends Operation {
  OriginationOperation({
    required int balance,
    required List<Map<String, dynamic>> code,
    required dynamic storage, // Micheline storage
    int? customFee,
  }) : super(
          kind: Kinds.origination,
          balance: balance,
          script: _script(code, storage),
          customFee: customFee,
        );

  String get contractAddress {
    return memo0<String>(() {
      if (operationsList == null) throw ArgumentError.notNull('operation.operationsList');

      // TODO: why does the node return a list of originated contracts ?
      return operationsList!
          .operations.first.simulationResult?['metadata']['operation_result']['originated_contracts'].first;
    })();
  }

  static Map<String, dynamic> _script(List<Map<String, dynamic>> code, dynamic storage) {
    return {'code': code, 'storage': storage};
  }
}
