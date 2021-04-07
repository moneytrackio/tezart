import 'dart:math';

import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';

import 'operation.dart';

class OperationHighLimits {
  final Operation operation;

  OperationHighLimits(this.operation);

  Future<int> get storage async {
    final hardStorageLimitPerOperation =
        int.parse((await _rpcInterface.constants())['hard_storage_limit_per_operation'] as String);
    final sourceBalanceStorageLimitation = await _rpcInterface.balance(operation.source.address);

    return min(hardStorageLimitPerOperation, sourceBalanceStorageLimitation);
  }

  Future<int> get gas async {
    return int.parse((await _rpcInterface.constants())['hard_gas_limit_per_operation'] as String);
  }

  RpcInterface get _rpcInterface {
    final operationsList = operation.operationsList;
    if (operationsList == null) throw ArgumentError.notNull('operationsList');

    return operationsList.rpcInterface;
  }
}
