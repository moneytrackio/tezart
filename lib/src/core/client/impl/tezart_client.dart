import 'package:logging/logging.dart';
import 'package:memoize/memoize.dart';
import 'package:meta/meta.dart';
import 'package:retry/retry.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operations_list/operations_list.dart';
import 'package:tezart/src/models/operation/origination_operation.dart';
import 'package:tezart/src/models/operation/reveal_operation.dart';
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
  Future<OperationsList> transfer({
    @required Keystore source,
    @required String destination,
    @required int amount,
    bool reveal = true,
  }) async {
    return _retryOnCounterError<OperationsList>(() async {
      return _catchHttpError<OperationsList>(() async {
        log.info('request transfer $amount µtz from $source.address to the destination $destination');

        final operationsList = OperationsList(source: source, rpcInterface: rpcInterface);
        if (reveal) await _prependRevealIfNotRevealed(operationsList, source);

        operationsList.addOperation(TransactionOperation(
          operationsList: operationsList,
          amount: amount,
          destination: destination,
        ));
        await operationsList.execute();

        return operationsList;
      });
    });
  }

  Future<void> _prependRevealIfNotRevealed(OperationsList list, Keystore source) async =>
      await isKeyRevealed(source.address) ? null : list.prependOperation(RevealOperation());

  /// Reveals [source.publicKey] and returns the operation group id
  ///
  /// It will reveal the public key associated to an address so that everyone
  /// can verify the signature for the operation and any future operations.
  Future<OperationsList> revealKey(Keystore source) async => _retryOnCounterError<OperationsList>(() async {
        return _catchHttpError<OperationsList>(() async {
          log.info('request to revealKey');
          final operation = RevealOperation();
          final operationsList = OperationsList(source: source, rpcInterface: rpcInterface)..addOperation(operation);
          await operationsList.execute();

          return operationsList;
        });
      });

  /// Returns `true` if the public key of [address] is revealed.
  Future<bool> isKeyRevealed(String address) async {
    return memo1<String, Future<bool>>((String address) async {
      log.info('request to find if isKeyRevealed');
      final managerKey = await rpcInterface.managerKey(address);

      return managerKey == null ? false : true;
    })(address);
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
  Future<String> monitorOperation(String operationId) {
    return _catchHttpError<String>(() => rpcInterface.monitorOperation(operationId: operationId));
  }

  Future<OperationsList> originateContract({
    @required Keystore source,
    @required List<Map<String, dynamic>> code,
    @required Map<String, dynamic> storage,
    @required int balance,
    int storageLimit, // TODO: remove this line because it must be computed via a dry run call
    bool reveal = true,
  }) async {
    //TODO: implement tests
    return _retryOnCounterError<OperationsList>(() async {
      return _catchHttpError<OperationsList>(() async {
        log.info('request to originateContract');

        var operationsList = OperationsList(source: source, rpcInterface: rpcInterface);
        if (reveal) await _prependRevealIfNotRevealed(operationsList, source);

        operationsList.addOperation(OriginationOperation(
          balance: balance,
          code: code,
          storage: storage,
          storageLimit: storageLimit,
        ));

        await operationsList.execute();

        return operationsList;
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
