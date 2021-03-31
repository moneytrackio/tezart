import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';

import 'operation.dart';

class RevealOperation extends Operation {
  RevealOperation(
    RpcInterface rpcInterface, {
    @required int counter,
    int storageLimit,
  }) : super(
          rpcInterface,
          kind: Kinds.reveal,
          counter: counter,
        );
}
