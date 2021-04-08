import 'package:tezart/tezart.dart';

import 'operation.dart';

class OperationFeesSetter {
  final Operation operation;

  static const _baseOperationMinimalFee = 100;
  static const _gasBuffer = 100;
  static const _minimalFeePerByte = 1;
  static const _minimalFeePerGas = 0.1;

  OperationFeesSetter(this.operation);

  Future<void> execute() async {
    operation.fee = operation.customFee ?? await _totalCost;
  }

  Future<int> get _burnFee async {
    if (operation.storageLimit == null) throw ArgumentError.notNull('operation.storageLimit');

    return (operation.storageLimit! * await _costPerBytes).ceil();
  }

  Future<int> get _costPerBytes async {
    return int.parse((await _operationsList.rpcInterface.constants())['cost_per_byte']);
  }

  int get _minimalFee {
    return (_baseOperationMinimalFee + _operationFee).ceil();
  }

  int get _operationFee {
    if (operation.gasLimit == null) throw ArgumentError.notNull('operation.gasLimit');

    return ((operation.gasLimit! + _gasBuffer) * _minimalFeePerGas + _operationSize * _minimalFeePerByte).ceil();
  }

  OperationsList get _operationsList {
    if (operation.operationsList == null) throw ArgumentError.notNull('operation.operationsList');

    return operation.operationsList!;
  }

  // TODO: Why divide by two ?
  int get _operationSize {
    if (_operationsList.result.forgedOperation == null) throw ArgumentError.notNull('operationsList.result');

    return (_operationsList.result.forgedOperation!.length / 2 / _operationsList.operations.length).ceil();
  }

  Future<int> get _totalCost async {
    return (await _burnFee) + _minimalFee;
  }
}
