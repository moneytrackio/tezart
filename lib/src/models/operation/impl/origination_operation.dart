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

  String get contractAddress {
    if (operationsList == null) throw ArgumentError.notNull('operation.operationsList');

    // TODO: why does the node return a list of originated contracts ?
    return operationsList!
        .operations.first.simulationResult?['metadata']['operation_result']['originated_contracts'].first;
  }
}
