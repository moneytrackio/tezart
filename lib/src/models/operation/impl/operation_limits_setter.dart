import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/models/operation/operation.dart';

import 'operation.dart';

class OperationLimitsSetter {
  final Operation operation;

  OperationLimitsSetter(this.operation);

  Future<void> execute() async {
    operation.gasLimit = simulationConsumedGas;
    operation.storageLimit = simulationStorageSize;

    if (operation.kind == Kinds.origination || _isDestinationContractAllocated) {
      operation.storageLimit += await originationDefaultSize;
    } else {
      operation.storageLimit = simulationStorageSize;
    }
  }

  // returns true if the operation is a transfer to an address unknown by the chain
  bool get _isDestinationContractAllocated {
    return operation.simulationResult['metadata']['operation_result']['allocated_destination_contract'] == true;
  }

  int get simulationStorageSize {
    return int.parse(operation.simulationResult['metadata']['operation_result']['paid_storage_size_diff'] ?? '0');
  }

  int get simulationConsumedGas {
    return int.parse(operation.simulationResult['metadata']['operation_result']['consumed_gas'] as String);
  }

  Future<int> get originationDefaultSize async {
    return (await _rpcInterface.constants())['origination_size'];
  }

  RpcInterface get _rpcInterface => operation.operationsList.rpcInterface;
}
