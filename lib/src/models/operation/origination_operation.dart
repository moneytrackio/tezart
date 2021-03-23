import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';

import 'operation.dart';

class OriginationOperation extends Operation {
  OriginationOperation(
    RpcInterface rpcInterface, {
    @required Keystore source,
    @required int balance,
    @required int counter,
    @required List<Map<String, dynamic>> code,
    @required Map<String, dynamic> storage,
    int storageLimit,
  }) : super(
          rpcInterface,
          kind: Kinds.origination,
          source: source,
          balance: balance,
          counter: counter,
          script: {
            'code': code,
            'storage': storage,
          },
          storageLimit: storageLimit,
        );
}
