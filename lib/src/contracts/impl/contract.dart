import 'package:memoize/memoize.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';

class Contract {
  final String contractAddress;
  final RpcInterface rpcInterface;

  Contract({required this.contractAddress, required this.rpcInterface});

  Future<int> get balance async => int.parse((await _contractInfo)['balance']);
  Future<Map<String, dynamic>> get storage async => (await _contractInfo)['script']['storage'];

  Future<List<String>> get entrypoints async =>
      memo0(() async => (await rpcInterface.getContractEntrypoints(contractAddress)).keys.toList())();

  Future<Map<String, dynamic>> get _contractInfo => rpcInterface.getContract(contractAddress);
}
