import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/models/operation_list/operation_list.dart';

import 'operation.dart';

class TransactionOperation extends Operation {
  TransactionOperation(
    RpcInterface rpcInterface, {
    @required OperationList operationList,
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
