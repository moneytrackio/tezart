import 'package:meta/meta.dart';
import 'package:tezart/keystore.dart';
import 'package:tezart/signature.dart';
import 'package:tezart/src/core/rpc_interface/operation/operation.dart';

import 'package:tezart/src/core/rpc_interface/rpc_interface.dart';
import 'package:tezart/src/exceptions/tezart_http_error.dart';
import 'package:tezart/src/exceptions/tezart_node_error.dart';
import 'package:tezart/exceptions.dart';

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
    final operation = TransactionOperation(
      amount: amount,
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

  Future<String> revealKey(Keystore source) async {
    try {
      final counter = await rpcInterface.counter(source.address) + 1;
      final operation =
          Operation(kind: Kinds.reveal, source: source.address, counter: counter, publicKey: source.publicKey);

      await rpcInterface.runOperations([operation]);

      final forgedOperation = await rpcInterface.forgeOperations([operation]);
      final signedOperationHex = Signature.fromHex(data: forgedOperation, keystore: source, watermark: 'generic').hex;

      return rpcInterface.injectOperation(signedOperationHex);
    } on TezartHttpError catch (e) {
      throw TezartNodeError.fromHttpError(e);
    }
  }

  Future<bool> isKeyRevealed(String address) async {
    final managerKey = await rpcInterface.managerKey(address);

    return managerKey == null ? false : true;
  }

  Future<int> getBalance({@required String address}) => rpcInterface.balance(address);
}
