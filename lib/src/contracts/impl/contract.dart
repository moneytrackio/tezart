import 'package:memoize/memoize.dart';
import 'package:tezart/tezart.dart';

/// A class that handles Tezos's contracts
///
/// - [contractAddress] is the address of this
///
/// It allows to :
/// - fetch the balance, storage, entrypoints of a contract
/// - compute the [OperationsList] related to a call of an entrypoint of a contract
///
/// If [contractAddress] is not found a [TezartHttpError] is thrown while calling a method of this
class Contract {
  final String contractAddress;
  final RpcInterface rpcInterface;

  Contract({required this.contractAddress, required this.rpcInterface});

  /// Returns the balance of this
  Future<int> get balance async => int.parse((await _contractInfo)['balance']);

  /// Returns the storage in Dart Type of this using [MichelineDecoder]
  Future<dynamic> get storage async {
    final contractInfo = await _contractInfo;
    final michelineStorage = contractInfo['script']['storage'];
    final type = await _storageType;

    return MichelineDecoder(type: type, data: michelineStorage).decode();
  }

  /// Returns a [List] containing the entrypoints of this
  Future<List<String>> get entrypoints async =>
      memo0(() async => (await rpcInterface.getContractEntrypoints(contractAddress)).keys.toList())();

  /// Returns a [OperationsList] containing a [TransactionOperation] related to a call of an entrypoint of the contract
  ///
  /// - [entrypoint] is the entrypoint we want to call. Default value is 'default'
  /// - [params] is the parameters in Dart Types of the call operation. [MichelineEncoder] is used for conversion to Micheline
  /// - [source] is the [Keystore] initiating the operation
  /// - [amount] is the amount of the operation. Default value is 0
  ///
  /// - when [params] are incompatible with the entrypoint signature, a [TypeError] is thrown
  Future<OperationsList> callOperation({
    String entrypoint = 'default',
    dynamic params,
    required Keystore source,
    int amount = 0,
    int? customFee,
    int? customGasLimit,
    int? customStorageLimit,
  }) async {
    final type = await _type(entrypoint);
    final michelineParams = MichelineEncoder(type: type, params: params).encode();

    return OperationsList(
      source: source,
      rpcInterface: rpcInterface,
    )..appendOperation(TransactionOperation(
        amount: amount,
        destination: contractAddress,
        params: michelineParams,
        entrypoint: entrypoint,
        customFee: customFee,
        customGasLimit: customGasLimit,
        customStorageLimit: customStorageLimit,
      ));
  }

  Future<Map<String, dynamic>> get _contractInfo => rpcInterface.getContract(contractAddress);
  Future<Map<String, dynamic>> get _storageType async {
    return memo0<Future<Map<String, dynamic>>>(() async {
      final contractInfo = await _contractInfo;
      final List code = contractInfo['script']['code'];

      return code.firstWhere((element) => element['prim'] == 'storage')['args'].first;
    })();
  }

  Future<Map<String, dynamic>> _type(String entrypoint) =>
      rpcInterface.getContractEntrypointType(address: contractAddress, entrypoint: entrypoint);
}
