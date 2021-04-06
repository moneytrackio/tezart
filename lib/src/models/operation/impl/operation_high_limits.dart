import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';

class OperationHighLimits {
  final RpcInterface rpcInterface;

  OperationHighLimits(this.rpcInterface);

  Future<int> get storage async {
    return int.parse((await rpcInterface.constants())['hard_storage_limit_per_operation'] as String);
  }

  Future<int> get gas async {
    return int.parse((await rpcInterface.constants())['hard_gas_limit_per_operation'] as String);
  }
}
