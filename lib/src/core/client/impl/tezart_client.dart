import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operation/operation.dart';
import 'package:tezart/src/signature/signature.dart';

import 'tezart_node_error.dart';

class TezartClient {
  final log = Logger('TezartClient');

  final RpcInterface rpcInterface;

  TezartClient(
      {@required String host, String port = '80', String scheme = 'http'})
      : rpcInterface = RpcInterface(host: host, port: port, scheme: scheme);

  Future<String> transfer({
    @required Keystore source,
    @required String destination,
    @required int amount,
  }) async {
    log.info('request transfer to the destination $destination');
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
      log.info('request to revealKey');
      final counter = await rpcInterface.counter(source.address) + 1;
      final operation = Operation(
          kind: Kinds.reveal,
          source: source.address,
          counter: counter,
          publicKey: source.publicKey);

      await rpcInterface.runOperations([operation]);

      final forgedOperation = await rpcInterface.forgeOperations([operation]);
      final signedOperationHex = Signature.fromHex(
              data: forgedOperation, keystore: source, watermark: 'generic')
          .hex;

      return rpcInterface.injectOperation(signedOperationHex);
    } on TezartHttpError catch (e) {
      log.severe('Error in revealKey', e);
      throw TezartNodeError.fromHttpError(e);
    }
  }

  Future<bool> isKeyRevealed(String address) async {
    log.info('request to find if isKeyRevealed');
    final managerKey = await rpcInterface.managerKey(address);

    return managerKey == null ? false : true;
  }

  Future<int> getBalance({@required String address}) {
    log.info('request to getBalance');
    return rpcInterface.balance(address);
  }
}
