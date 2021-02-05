import 'package:meta/meta.dart';
import 'package:tezart/keystore.dart';
import 'package:tezart/signature.dart';
import 'package:tezart/src/core/rpc_interface/operation/operation.dart';

import 'package:tezart/src/core/rpc_interface/rpc_interface.dart';

class Tezart {
  final RpcInterface rpcInterface;

  Tezart({@required String host, String port = '80', String scheme = 'http'})
      : rpcInterface = RpcInterface(host: host, port: port, scheme: scheme);

  Future<String> transfer({
    @required Keystore source,
    @required String destination,
    @required int amount,
  }) async {
    final counter = await rpcInterface.counter(source.address) + 1;
    final operation = Operation(
      amount: amount,
      kind: Kinds.transaction,
      source: source.address,
      destination: destination,
      counter: counter,
    );

    await rpcInterface.runOperations([operation]);

    final forgedOperation = await rpcInterface.forgeOperations([operation]);
    final signedOperationHex = Signature.fromHex(
      data: forgedOperation,
      keystore: source,
      watermark: 'generic',
    ).hex;

    return rpcInterface.injectOperation(signedOperationHex);
  }
}
