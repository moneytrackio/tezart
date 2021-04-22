import 'package:tezart/src/models/operation/impl/operation_visitor.dart';

import 'operation.dart';

class OperationFeesSetterVisitor implements OperationVisitor {
  static const _baseOperationMinimalFee = 100;
  static const _gasBuffer = 100;
  static const _minimalFeePerByte = 1;
  static const _minimalFeePerGas = 0.1;

  @override
  Future<void> visit(Operation operation) async {
    operation.fee = operation.customFee ?? await _totalCost(operation);
  }

  Future<int> _burnFee(Operation operation) async {
    return (operation.storageLimit * await _costPerBytes(operation)).ceil();
  }

  Future<int> _costPerBytes(Operation operation) async {
    return int.parse((await operation.operationsList.rpcInterface.constants())['cost_per_byte']);
  }

  int _minimalFee(Operation operation) {
    return (_baseOperationMinimalFee + _operationFee(operation)).ceil();
  }

  int _operationFee(Operation operation) {
    return ((operation.gasLimit + _gasBuffer) * _minimalFeePerGas + _operationSize(operation) * _minimalFeePerByte)
        .ceil();
  }

  // TODO: Why divide by two ?
  int _operationSize(Operation operation) {
    final operationsList = operation.operationsList;

    return (operationsList.result.forgedOperation.length / 2 / operationsList.operations.length).ceil();
  }

  Future<int> _totalCost(Operation operation) async {
    return (await _burnFee(operation)) + _minimalFee(operation);
  }
}
