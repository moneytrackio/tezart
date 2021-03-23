import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';

import 'operation.dart';

class RevealOperation extends Operation {
  RevealOperation(
    RpcInterface rpcInterface, {
    @required Keystore source,
    @required int counter,
    int storageLimit,
  }) : super(
          rpcInterface,
          kind: Kinds.reveal,
          source: source,
          counter: counter,
          publicKey: source.publicKey,
        );
}
