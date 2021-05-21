import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/models/operation/impl/operation_visitor.dart';
import 'package:tezart/src/models/operation/operation.dart';

import 'operation.dart';

class OperationLimitsSetterVisitor implements OperationVisitor {
  @override
  Future<void> visit(Operation operation) async {
    operation.gasLimit = _simulationConsumedGas(operation);
    operation.storageLimit = _simulationStorageSize(operation);

    if (operation.kind == Kinds.origination || _isDestinationContractAllocated(operation)) {
      operation.storageLimit = operation.storageLimit! + await _originationDefaultSize(operation);
    } else {
      operation.storageLimit = _simulationStorageSize(operation);
    }
  }

  // returns true if the operation is a transfer to an address unknown by the chain
  bool _isDestinationContractAllocated(Operation operation) {
    return _simulationResult(operation)['metadata']['operation_result']['allocated_destination_contract'] == true;
  }

  int _simulationStorageSize(Operation operation) {
    return int.parse(_simulationResult(operation)['metadata']['operation_result']['paid_storage_size_diff'] ?? '0');
  }

  int _simulationConsumedGas(Operation operation) {
    return int.parse(_simulationResult(operation)['metadata']['operation_result']['consumed_gas'] as String);
  }

  Future<int> _originationDefaultSize(Operation operation) async {
    return (await _rpcInterface(operation).constants())['origination_size'];
  }

  Map<String, dynamic> _simulationResult(Operation operation) {
    if (operation.simulationResult == null) throw ArgumentError.notNull('operation.simulationResult');

    return operation.simulationResult!;
  }

  RpcInterface _rpcInterface(Operation operation) {
    if (operation.operationsList == null) throw ArgumentError.notNull('operation.operationsList');

    return operation.operationsList!.rpcInterface;
  }
}
