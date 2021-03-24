import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:retry/retry.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operation/operation.dart';
import 'package:tezart/src/signature/signature.dart';

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
    if (reveal) await _revealKeyIfNotRevealed(source);

    return _retryOnCounterError(() async {
      return _catchHttpError<String>(() async {
        log.info('request transfer $amount µtz from $source.address to the destination $destination');

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
          watermark: Watermarks.generic,
        ).hexIncludingPayload;

        return rpcInterface.injectOperation(signedOperationHex);
      });
    });
  }

  Future<void> _revealKeyIfNotRevealed(Keystore source) async {
    if (source.isKeyRevealed) return;
    if (!await isKeyRevealed(source.address)) {
      final opId = await revealKey(source);
      await monitorOperation(opId);
      source.isKeyRevealed = true;
    }
  }

  /// Reveals [source.publicKey] and returns the operation group id
  ///
  /// It will reveal the public key associated to an address so that everyone
  /// can verify the signature for the operation and any future operations.
  Future<String> revealKey(Keystore source) async => _retryOnCounterError(() async {
        return _catchHttpError<String>(() async {
          log.info('request to revealKey');
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
            watermark: Watermarks.generic,
          ).hexIncludingPayload;

          return rpcInterface.injectOperation(signedOperationHex);
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
    return _catchHttpError(() => rpcInterface.balance(address));
  }

  /// Waits for [operationId] to be included in a block.
  ///
  /// ```dart
  /// final operationId = await client.revealKey(source);
  /// await client.monitorOperation(operationId);
  /// ```
  Future<void> monitorOperation(String operationId) {
    log.info('request to monitorOperation');
    return _catchHttpError(() => rpcInterface.monitorOperation(operationId: operationId));
  }

  Future<String> originateContract({
    @required Keystore source,
    @required List<Map<String, dynamic>> code,
    @required Map<String, dynamic> storage,
    @required int balance,
    int storageLimit, // TODO: remove this line because it must be computed via a dry run call
    bool reveal = true,
  }) async {
    if (reveal) await _revealKeyIfNotRevealed(source);
    //TODO: implement tests
    return _retryOnCounterError(() async {
      return _catchHttpError<String>(() async {
        log.info('request to originateContract');
        final counter = await rpcInterface.counter(source.address) + 1;
        final operation = OriginationOperation(
          source: source.address,
          balance: balance,
          counter: counter,
          code: code,
          storage: storage,
          storageLimit: storageLimit,
        );

        await rpcInterface.runOperations([operation]);

        final forgedOperation = await rpcInterface.forgeOperations([operation]);
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
