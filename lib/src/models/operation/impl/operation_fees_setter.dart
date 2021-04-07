import 'operation.dart';

class OperationFeesSetter {
  final Operation operation;

  static const _baseOperationMinimalFee = 100;
  static const _gasBuffer = 100;
  static const _minimalFeePerByte = 1;
  static const _minimalFeePerGas = 0.1;

  OperationFeesSetter(this.operation);

  Future<void> execute() async {
    operation.fee = await _totalCost;
  }

  Future<int> get _burnFee async {
    return (operation.storageLimit * await _costPerBytes).ceil();
  }

  Future<int> get _costPerBytes async {
    return int.parse((await operation.operationsList.rpcInterface.constants())['cost_per_byte']);
  }

  int get _minimalFee {
    return (_baseOperationMinimalFee + _operationFee).ceil();
  }

  int get _operationFee {
    return ((operation.gasLimit + _gasBuffer) * _minimalFeePerGas + _operationSize * _minimalFeePerByte).ceil();
  }

  // TODO: Why divide by two ?
  int get _operationSize {
    final operationsList = operation.operationsList;

    return (operationsList.result.forgedOperation.length / 2 / operationsList.operations.length).ceil();
  }

  Future<int> get _totalCost async {
    return (await _burnFee) + _minimalFee;
  }
}
