import 'package:tezart/src/models/operation/impl/operation_visitor.dart';

import 'operation.dart';

class OperationFeesSetterVisitor implements OperationVisitor {
  static const _baseOperationMinimalFee = 100;
  static const _minimalFeePerByte = 1;
  static const _minimalFeePerGas = 0.1;
  static const _signatureSize = 64;

  @override
  Future<void> visit(Operation operation) async {
    operation.fee = operation.customFee ?? await _totalCost(operation);
  }

  Future<int> _burnFee(Operation operation) async {
    if (operation.storageLimit == null) throw ArgumentError.notNull('operation.storageLimit');

    return (operation.storageLimit! * await _costPerBytes(operation)).ceil();
  }

  Future<int> _costPerBytes(Operation operation) async {
    if (operation.operationsList == null) throw ArgumentError.notNull('operation.operationsList');

    return int.parse((await operation.operationsList!.rpcInterface.constants())['cost_per_byte']);
  }

  int _minimalFee(Operation operation) {
    return (_baseOperationMinimalFee + _operationFee(operation)).ceil();
  }

  int _operationFee(Operation operation) {
    if (operation.gasLimit == null) throw ArgumentError.notNull('operation.gasLimit');

    final gasFee = operation.gasLimit! * _minimalFeePerGas;
    final sizeFee = _operationSize(operation) * _minimalFeePerByte;

    return (gasFee + sizeFee).ceil();
  }

  int _operationSize(Operation operation) {
    return (_signedOperationListSize(operation) / operation.operationsList!.operations.length).ceil();
  }

  int _signedOperationListSize(Operation operation) {
    return (_unsignedOperationListSize(operation) + _signatureSize);
  }

  int _unsignedOperationListSize(Operation operation) {
    final operationsList = operation.operationsList;
    if (operationsList == null) throw ArgumentError.notNull('operation.operationsList');

    final operationsListResult = operationsList.result;
    if (operationsListResult.forgedOperation == null) {
      throw ArgumentError.notNull('operation.operationsList.result.forgedOperation');
    }
    return (operationsList.result.forgedOperation!.length / 2).ceil();
  }

  Future<int> _totalCost(Operation operation) async {
    final burnFee = await _burnFee(operation);
    final minimalFee = _minimalFee(operation);

    return (burnFee + minimalFee);
  }
}
