import 'package:memoize/memoize.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/micheline_decoder/impl/micheline_decoder.dart';
import 'package:tezart/src/micheline_encoder/impl/micheline_encoder.dart';
import 'package:tezart/tezart.dart';

class Contract {
  final String contractAddress;
  final RpcInterface rpcInterface;

  Contract({required this.contractAddress, required this.rpcInterface});

  Future<int> get balance async => int.parse((await _contractInfo)['balance']);

  Future<dynamic> get storage async {
    final contractInfo = await _contractInfo;
    final michelineStorage = contractInfo['script']['storage'];
    final schema = await _storageType;

    return MichelineDecoder(schema: schema, data: michelineStorage).decode();
  }

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
  Future<Map<String, dynamic>> get _storageType async {
    return memo0<Future<Map<String, dynamic>>>(() async {
      final contractInfo = await _contractInfo;
      final List code = contractInfo['script']['code'];

      return code.firstWhere((element) => element['prim'] == 'storage')['args'].first;
    })();
  }

  Future<Map<String, dynamic>> _schema(String entrypoint) =>
      rpcInterface.getContractEntrypointSchema(address: contractAddress, entrypoint: entrypoint);
}
