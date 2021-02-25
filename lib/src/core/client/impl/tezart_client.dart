import 'package:meta/meta.dart';
import 'package:retry/retry.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operation/operation.dart';
import 'package:tezart/src/signature/signature.dart';

import 'tezart_node_error.dart';

class TezartClient {
  final RpcInterface rpcInterface;

  TezartClient({@required String host, String port = '80', String scheme = 'http'})
      : rpcInterface = RpcInterface(host: host, port: port, scheme: scheme);

  Future<String> transfer({
    @required Keystore source,
    @required String destination,
    @required int amount,
  }) async {
    return _retryOnCounterError(() async {
      return _catchHttpError<String>(() async {
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
        ).hexIncludingPayload;

        return rpcInterface.injectOperation(signedOperationHex);
      });
    });
  }

  Future<String> revealKey(Keystore source) async {
    return _retryOnCounterError(() async {
      return _catchHttpError<String>(() async {
        final counter = await rpcInterface.counter(source.address) + 1;
        final operation = Operation(
          kind: Kinds.reveal,
          source: source.address,
          counter: counter,
          publicKey: source.publicKey,
        );

        await rpcInterface.runOperations([operation]);

        final forgedOperation = await rpcInterface.forgeOperations([operation]);
        final signedOperationHex = Signature.fromHex(
          data: forgedOperation,
          keystore: source,
          watermark: 'generic',
        ).hexIncludingPayload;

        return rpcInterface.injectOperation(signedOperationHex);
      });
    });
  }

  Future<bool> isKeyRevealed(String address) async {
    final managerKey = await rpcInterface.managerKey(address);

    return managerKey == null ? false : true;
  }

  Future<int> getBalance({@required String address}) => rpcInterface.balance(address);
  Future<void> monitorOperation(String operationId) => rpcInterface.monitorOperation(operationId: operationId);

  Future<T> _retryOnCounterError<T>(func) {
    final r = RetryOptions(maxAttempts: 3);
    return r.retry(
      func,
      retryIf: (e) => e is TezartNodeError && e.type == TezartNodeErrorTypes.counter_error,
    );
  }

  Future<T> _catchHttpError<T>(Function func) async {
    try {
      return await func();
    } on TezartHttpError catch (e) {
      throw TezartNodeError.fromHttpError(e);
    }
  }
}
