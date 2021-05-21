import 'dart:math';

import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/models/operation/impl/operation_visitor.dart';

import 'operation.dart';

class OperationHardLimitsSetterVisitor implements OperationVisitor {
  @override
  Future<void> visit(Operation operation) async {
    operation.storageLimit = await _storage(operation);
    operation.gasLimit = await _gas(operation);
  }

  Future<int> _storage(Operation operation) async {
    final hardStorageLimitPerOperation =
        int.parse((await _rpcInterface(operation).constants())['hard_storage_limit_per_operation'] as String);
    final sourceBalanceStorageLimitation = await _rpcInterface(operation).balance(operation.source.address);

    return min(hardStorageLimitPerOperation, sourceBalanceStorageLimitation);
  }

  Future<int> _gas(Operation operation) async {
    return int.parse((await _rpcInterface(operation).constants())['hard_gas_limit_per_operation'] as String);
  }

  RpcInterface _rpcInterface(Operation operation) {
    final operationsList = operation.operationsList;
    if (operationsList == null) throw ArgumentError.notNull('operationsList');

    return operationsList.rpcInterface;
  }
}
