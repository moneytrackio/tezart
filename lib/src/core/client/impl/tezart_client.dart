import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:retry/retry.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operation/operation.dart';
import 'package:tezart/src/models/operation_list/operation_list.dart';
import 'package:tezart/src/signature/signature.dart';
import 'package:tezart/src/models/operation/operation_result.dart';
import 'package:tezart/src/models/operation/origination_operation.dart';
import 'package:tezart/src/models/operation/transaction_operation.dart';

import 'tezart_node_error.dart';

/// A client that connects to the Tezos node.
///
/// ```dart
/// final client = TezartClient('http://localhost:20000/');
/// ```
///
/// The methods throw [TezartNodeError] if a node error occurs.\
/// Injection operations are retried 3 times if a counter error ocurs.\
/// Amounts are in µtz. 1tz = 1000000µtz.
class TezartClient {
  final log = Logger('TezartClient');

  /// A [RpcInterface] instance, generated using `url`
  final RpcInterface rpcInterface;

  /// Default constructor.
  TezartClient(String url) : rpcInterface = RpcInterface(url);

  /// Transfers [amount] from [source] to [destination] and returns the operation group id.\
  ///
  /// ```dart
  /// final source = Keystore.fromSecretKey('edskRpm2mUhvoUjHjXgMoDRxMKhtKfww1ixmWiHCWhHuMEEbGzdnz8Ks4vgarKDtxok7HmrEo1JzkXkdkvyw7Rtw6BNtSd7MJ7');
  /// final destination = 'tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW';
  /// final amount = 1000;
  /// await client.transfer(source: source, destination: destionation, amount: amount);
  /// ```
  ///
  /// Retries 3 times if a counter error occurs ([TezartNodeErrorTypes.counterError]).
  Future<String> transfer({
    @required Keystore source,
    @required String destination,
    @required int amount,
    bool reveal = true,
  }) async {
    return _retryOnCounterError<String>(() async {
      return _catchHttpError<String>(() async {
        log.info('request transfer $amount µtz from $source.address to the destination $destination');

        final ops = OperationList();
        if (reveal) await _prependRevealIfNotRevealed(ops, source);

        var counter = await rpcInterface.counter(source.address) + 1;
        ops.addOperation(TransactionOperation(
          rpcInterface,
          amount: amount,
          source: source,
          destination: destination,
          counter: counter,
        ));
        await rpcInterface.runOperations(ops.opsList);

        final forgedOperation = await rpcInterface.forgeOperations(ops.opsList);
        final signedOperationHex = Signature.fromHex(
          data: forgedOperation,
          keystore: source,
          watermark: Watermarks.generic,
        ).hexIncludingPayload;

        return rpcInterface.injectOperation(signedOperationHex);
      });
    });
  }

  Future<void> _prependRevealIfNotRevealed(OperationList list, Keystore source) async {
    if (source.isKeyRevealed) return;
    if (!await isKeyRevealed(source.address)) {
      list.prependOperation(await getRevealOperation(source));
    }
  }

  Future<Operation> getRevealOperation(Keystore source) async {
    final counter = await rpcInterface.counter(source.address) + 1;
    return Operation(
      rpcInterface,
      kind: Kinds.reveal,
      source: source,
      counter: counter,
      publicKey: source.publicKey,
    );
  }

  /// Reveals [source.publicKey] and returns the operation group id
  ///
  /// It will reveal the public key associated to an address so that everyone
  /// can verify the signature for the operation and any future operations.
  Future<OperationResult> revealKey(Keystore source) async => _retryOnCounterError<OperationResult>(() async {
        return _catchHttpError<OperationResult>(() async {
          log.info('request to revealKey');
          final counter = await rpcInterface.counter(source.address) + 1;
          final operation = Operation(
            rpcInterface,
            kind: Kinds.reveal,
            source: source,
            counter: counter,
            publicKey: source.publicKey,
          );

          return operation.execute();
        });
      });

  /// Returns `true` if the public key of [address] is revealed.
  Future<bool> isKeyRevealed(String address) async {
    log.info('request to find if isKeyRevealed');
    final managerKey = await rpcInterface.managerKey(address);

    return managerKey == null ? false : true;
  }

  /// Returns the balance in µtz of `address`.
  Future<int> getBalance({@required String address}) {
    log.info('request to getBalance');
    return _catchHttpError<int>(() => rpcInterface.balance(address));
  }

  /// Waits for [operationId] to be included in a block.
  ///
  /// ```dart
  /// final operationId = await client.revealKey(source);
  /// await client.monitorOperation(operationId);
  /// ```
  Future<void> monitorOperation(String operationId) {
    log.info('request to monitorOperation');
    return _catchHttpError<void>(() => rpcInterface.monitorOperation(operationId: operationId));
  }

  Future<String> originateContract({
    @required Keystore source,
    @required List<Map<String, dynamic>> code,
    @required Map<String, dynamic> storage,
    @required int balance,
    int storageLimit, // TODO: remove this line because it must be computed via a dry run call
    bool reveal = true,
  }) async {
    //TODO: implement tests
    return _retryOnCounterError<String>(() async {
      return _catchHttpError<String>(() async {
        log.info('request to originateContract');

        var ops = OperationList();
        if (reveal) await _prependRevealIfNotRevealed(ops, source);

        final counter = await rpcInterface.counter(source.address) + 1;
        ops.addOperation(OriginationOperation(
          rpcInterface,
          source: source,
          balance: balance,
          counter: counter,
          code: code,
          storage: storage,
          storageLimit: storageLimit,
        ));

        await rpcInterface.runOperations(ops.opsList);

        final forgedOperation = await rpcInterface.forgeOperations(ops.opsList);
        final signedOperationHex = Signature.fromHex(
          data: forgedOperation,
          keystore: source,
          watermark: Watermarks.generic,
        ).hexIncludingPayload;

        return rpcInterface.injectOperation(signedOperationHex);
      });
    });
  }

  Future<T> _retryOnCounterError<T>(func) {
    final r = RetryOptions(maxAttempts: 3);
    return r.retry(
      func,
      retryIf: (e) => e is TezartNodeError && e.type == TezartNodeErrorTypes.counterError,
    );
  }

  Future<T> _catchHttpError<T>(Future<T> Function() func) async {
    try {
      return await func();
    } on TezartHttpError catch (e) {
      log.severe('Http Error', e);
      throw TezartNodeError.fromHttpError(e);
    }
  }
}
