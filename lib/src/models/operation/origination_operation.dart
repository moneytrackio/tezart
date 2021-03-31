import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';

import 'operation.dart';

class OriginationOperation extends Operation {
  OriginationOperation(
    RpcInterface rpcInterface, {
    @required int balance,
    @required int counter,
    @required List<Map<String, dynamic>> code,
    @required Map<String, dynamic> storage,
    int storageLimit,
  }) : super(
          kind: Kinds.origination,
          balance: balance,
          counter: counter,
          script: {
            'code': code,
            'storage': storage,
          },
          storageLimit: storageLimit,
        );
}
