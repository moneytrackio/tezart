import 'package:logging/logging.dart';
import 'package:memoize/memoize.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operation/operation.dart';
import 'package:tezart/src/models/operations_list/operations_list.dart';

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

  /// Returns an [OperationsList] containing a [TransactionOperation] that transfers [amount] from [source]
  /// to [destination] and returns the operation group id.\
  ///
  /// - [customFee] if set, will be used instead of the default fees computed by OperationFeesSetterVisitor
  /// - [customGasLimit] if set, will be used instead of the default gasLimit computed by OperationFeesSetterVisitor
  /// - [customStorageLimit] if set, will be used instead of the default storageLimit computed by OperationFeesSetterVisitor
  /// - [reveal] if set to true, will prepend a [RevealOperation] if [source] is not already revealed
  ///
  /// ```dart
  /// final source = Keystore.fromSecretKey('edskRpm2mUhvoUjHjXgMoDRxMKhtKfww1ixmWiHCWhHuMEEbGzdnz8Ks4vgarKDtxok7HmrEo1JzkXkdkvyw7Rtw6BNtSd7MJ7');
  /// final destination = 'tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW';
  /// final amount = 1000;
  /// await client.transferOperation(source: source, destination: destionation, amount: amount);
  /// ```
  ///
  /// Retries 3 times if a counter error occurs ([TezartNodeErrorTypes.counterError]).
  Future<OperationsList> transferOperation({
    required Keystore source,
    required String destination,
    required int amount,
    int? customFee,
    int? customGasLimit,
    int? customStorageLimit,
    bool reveal = true,
  }) async {
    return _catchHttpError<OperationsList>(() async {
      log.info(
          'request transfer $amount µtz from $source.address to the destination $destination');

      final operationsList =
          OperationsList(source: source, rpcInterface: rpcInterface)
            ..appendOperation(
              TransactionOperation(
                amount: amount,
                destination: destination,
                customFee: customFee,
                customGasLimit: customGasLimit,
                customStorageLimit: customStorageLimit,
              ),
            );
      if (reveal) {
        await _prependRevealIfNotRevealed(
          operationsList,
          source,
          customFee: customFee,
          customGasLimit: customGasLimit,
          customStorageLimit: customStorageLimit,
        );
      }

      return operationsList;
    });
  }

  Future<OperationsList> transferFA12Tokens({
    required Keystore source,
    required String destination,
    required String contractAddress,
    required int amount,
    int? customFee,
    int? customGasLimit,
    int? customStorageLimit,
    bool reveal = true,
  }) async {
    final michelineParams = {
      'prim': 'Pair',
      'args': [
        {'string': source.address},
        {
          'prim': 'Pair',
          'args': [
            {'string': destination},
            {'int': amount.toString()}
          ]
        }
      ]
    };

    return _catchHttpError<OperationsList>(() async {
      log.info('Transfering FA1.2 Tokens');

      final operationsList =
          OperationsList(source: source, rpcInterface: rpcInterface)
            ..appendOperation(
              TransactionOperation(
                entrypoint: 'transfer',
                amount: amount,
                destination: destination,
                customFee: customFee,
                customGasLimit: customGasLimit,
                customStorageLimit: customStorageLimit,
                params: michelineParams,
              ),
            );

      if (reveal) {
        await _prependRevealIfNotRevealed(
          operationsList,
          source,
          customFee: customFee,
          customGasLimit: customGasLimit,
          customStorageLimit: customStorageLimit,
        );
      }

      return operationsList;
    });
  }

  Future<OperationsList> transferFA2Tokens({
    required Keystore source,
    required String destination,
    required String contractAddress,
    required int tokenID,
    required int amount,
    int? customFee,
    int? customGasLimit,
    int? customStorageLimit,
    bool reveal = true,
  }) async {
    final michelineParams = {
      'entrypoint': 'transfer',
      'value': [
        {
          'prim': 'Pair',
          'args': [
            {'string': source.address},
            [
              {
                'prim': 'Pair',
                'args': [
                  {'string': destination},
                  {
                    'prim': 'Pair',
                    'args': [
                      {'int': tokenID.toString()},
                      {'int': amount.toString()},
                    ]
                  },
                ],
              }
            ]
          ]
        }
      ]
    };

    return _catchHttpError<OperationsList>(() async {
      log.info('Transfering FA2 Tokens');

      final operationsList =
          OperationsList(source: source, rpcInterface: rpcInterface)
            ..appendOperation(
              TransactionOperation(
                amount: amount,
                destination: destination,
                customFee: customFee,
                customGasLimit: customGasLimit,
                customStorageLimit: customStorageLimit,
                params: michelineParams,
              ),
            );

      if (reveal) {
        await _prependRevealIfNotRevealed(
          operationsList,
          source,
          customFee: customFee,
          customGasLimit: customGasLimit,
          customStorageLimit: customStorageLimit,
        );
      }

      return operationsList;
    });
  }

  /// Returns an [OperationsList] that reveals [source] publicKey.
  OperationsList revealKeyOperation(
    Keystore source, {
    int? customFee,
    int? customGasLimit,
    int? customStorageLimit,
  }) {
    log.info('request to revealKey');

    return OperationsList(source: source, rpcInterface: rpcInterface)
      ..appendOperation(RevealOperation(
        customFee: customFee,
        customGasLimit: customGasLimit,
        customStorageLimit: customStorageLimit,
      ));
  }

  /// Returns `true` if the public key of [address] is revealed.
  Future<bool> isKeyRevealed(String address) async {
    return memo1<String, Future<bool>>((String address) async {
      log.info('request to find if isKeyRevealed');
      final managerKey = await rpcInterface.managerKey(address);

      return managerKey != null;
    })(address);
  }

  /// Returns the balance in µtz of `address`.
  Future<int> getBalance({required String address}) {
    log.info('request to getBalance');
    return _catchHttpError<int>(() => rpcInterface.balance(address));
  }

  /// Waits for [operationId] to be included in a block.
  ///
  /// ```dart
  /// final operationsList = await client.revealKeyOperation(source);
  /// await operationsList.execute();
  /// await client.monitorOperation(operationsList.result.id);
  /// ```
  Future<String> monitorOperation(String operationId) {
    return _catchHttpError<String>(() async {
      log.info('monitoring the operation $operationId');

      return rpcInterface.monitorOperation(operationId: operationId);
    });
  }

  /// Returns an [OperationsList] that originates a contract initiated by [source]
  ///
  /// - [source] is the [Keystore] initiating the operation
  /// - [code] is the code of the smart contract in Micheline
  /// - [storage] is the initial storage of the contract in Micheline
  /// - [balance] is the balance of the originated contract
  /// - [customFee] if set, will be used instead of the default fees computed by OperationFeesSetterVisitor
  /// - [customGasLimit] if set, will be used instead of the default gasLimit computed by OperationFeesSetterVisitor
  /// - [customStorageLimit] if set, will be used instead of the default storageLimit computed by OperationFeesSetterVisitor
  /// - [reveal] if set to true, will prepend a [RevealOperation] if [source] is not already revealed
  ///
  Future<OperationsList> originateContractOperation({
    required Keystore source,
    required List<Map<String, dynamic>> code,
    required dynamic storage,
    required int balance,
    int? customFee,
    int? customGasLimit,
    int? customStorageLimit,
    bool reveal = true,
  }) async {
    return _catchHttpError<OperationsList>(() async {
      log.info('request to originateContract');

      var operationsList = OperationsList(
        source: source,
        rpcInterface: rpcInterface,
      )..appendOperation(
          OriginationOperation(
            balance: balance,
            code: code,
            storage: storage,
            customFee: customFee,
            customGasLimit: customGasLimit,
            customStorageLimit: customStorageLimit,
          ),
        );
      if (reveal) {
        await _prependRevealIfNotRevealed(
          operationsList,
          source,
          customFee: customFee,
          customGasLimit: customGasLimit,
          customStorageLimit: customStorageLimit,
        );
      }

      return operationsList;
    });
  }

  Future<T> _catchHttpError<T>(Future<T> Function() func) {
    return catchHttpError<T>(func, onError: (TezartHttpError e) {
      log.severe('Http Error', e);
    });
  }

  Future<void> _prependRevealIfNotRevealed(
    OperationsList list,
    Keystore source, {
    int? customFee,
    int? customGasLimit,
    int? customStorageLimit,
  }) async =>
      await isKeyRevealed(source.address)
          ? null
          : list.prependOperation(RevealOperation(
              customFee: customFee,
              customGasLimit: customGasLimit,
              customStorageLimit: customStorageLimit,
            ));
}
