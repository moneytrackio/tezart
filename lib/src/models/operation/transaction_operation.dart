import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';

import 'operation.dart';

class TransactionOperation extends Operation {
  TransactionOperation(
    RpcInterface rpcInterface, {
    @required int amount,
    @required Keystore source,
    @required String destination,
    @required int counter,
  }) : super(
          rpcInterface,
          kind: Kinds.transaction,
          source: source,
          destination: destination,
          amount: amount,
          counter: counter,
        );
}
