import 'package:memoize/memoize.dart';

import 'operation.dart';

class OriginationOperation extends Operation {
  OriginationOperation({
    required int balance,
    required List<Map<String, dynamic>> code,
    required Map<String, dynamic> storage,
    int? customFee,
  }) : super(
          kind: Kinds.origination,
          balance: balance,
          script: {
            'code': code,
            'storage': storage,
          },
          customFee: customFee,
        );

  Future<String> get contractAddress async {
    // TODO: fix and use simulation result instead
    return memo0<Future<String>>(() async {
      final blockHash = operationsList?.result.blockHash;
      if (blockHash == null) throw ArgumentError.notNull('blockHash');

      final block = await operationsList!.rpcInterface.block(chain: 'main', level: blockHash);
      final appliedOperations = block['operations'][3];
      final operationsGroup = appliedOperations.firstWhere((element) => element['hash'] == operationsList!.result.id!);
      // TODO: what to do when there is multiple origination in the same group?
      final Map<String, dynamic> originationOperationContent =
          operationsGroup['contents'].firstWhere((element) => element['kind'] == 'origination');

      return originationOperationContent['metadata']['operation_result']['originated_contracts'].first;
    })();
  }
}
