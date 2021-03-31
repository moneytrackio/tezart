import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/models/operations_list/operations_list.dart';

import 'operation.dart';

class TransactionOperation extends Operation {
  TransactionOperation(
    RpcInterface rpcInterface, {
    @required OperationsList operationsList,
    @required int amount,
    @required String destination,
    @required int counter,
  }) : super(
          rpcInterface,
          kind: Kinds.transaction,
          destination: destination,
          amount: amount,
          counter: counter,
        );
}
