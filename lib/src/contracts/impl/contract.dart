import 'package:memoize/memoize.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/micheline_encoder/impl/micheline_encoder.dart';
import 'package:tezart/tezart.dart';

class Contract {
  final String contractAddress;
  final RpcInterface rpcInterface;

  Contract({required this.contractAddress, required this.rpcInterface});

  Future<int> get balance async => int.parse((await _contractInfo)['balance']);
  Future<Map<String, dynamic>> get storage async => (await _contractInfo)['script']['storage'];

  Future<List<String>> get entrypoints async =>
      memo0(() async => (await rpcInterface.getContractEntrypoints(contractAddress)).keys.toList())();

  Future<OperationsList> callOperation({
    String entrypoint = 'default',
    dynamic? params,
    required Keystore source,
    int amount = 0,
  }) async {
    final schema = await _schema(entrypoint);
    final michelineParams = MichelineEncoder(schema: schema, params: params).encode();

    return OperationsList(
      source: source,
      rpcInterface: rpcInterface,
    )..appendOperation(TransactionOperation(
        amount: amount,
        destination: contractAddress,
        params: michelineParams,
        entrypoint: entrypoint,
      ));
  }

  Future<Map<String, dynamic>> get _contractInfo => rpcInterface.getContract(contractAddress);

  Future<Map<String, dynamic>> _schema(String entrypoint) =>
      rpcInterface.getContractEntrypointSchema(address: contractAddress, entrypoint: entrypoint);
}
