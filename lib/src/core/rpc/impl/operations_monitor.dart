import 'dart:convert';

import 'package:tezart/src/core/client/impl/tezart_node_error.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';

import 'rpc_interface_paths.dart' as paths;

class OperationsMonitor {
  final RpcInterface rpcInterface;

  OperationsMonitor(this.rpcInterface);

  Future<String> monitor({
    required String chain,
    required String level,
    required String operationId,
  }) async {
    // TODO: compute timeout based on time between blocks (problem in the CI when the blockchain just started)
    const timeoutBetweenChunks = Duration(minutes: 3);
    const nbOfBlocksToWait = 2;

    final predHash = await _predecessorHash(chain: chain, level: level);
    final isOpIdIncludedInPredBlock = await _isOperationIdIncludedInBlock(
      blockHash: predHash,
      operationId: operationId,
    );
    if (isOpIdIncludedInPredBlock) return predHash;

    final rs = await rpcInterface.httpClient.getStream(paths.monitor(chain));
    await for (var value in rs.data?.stream.timeout(timeoutBetweenChunks).take(nbOfBlocksToWait) ?? Stream.empty()) {
      final decodedValue = json.decode(String.fromCharCodes(value));
      final headBlockHash = decodedValue['hash'];
      final isOpIdIncludedInBlock = await _isOperationIdIncludedInBlock(
        blockHash: headBlockHash,
        operationId: operationId,
      );

      if (isOpIdIncludedInBlock) return headBlockHash;
    }

    throw TezartNodeError(
      type: TezartNodeErrorTypes.monitoringTimedOut,
      metadata: {'operationId': operationId},
    );
  }

  Future<String> _predecessorHash({required String chain, required String level}) async {
    final block = await rpcInterface.block(chain: chain, level: level);

    return block['header']['predecessor'] as String;
  }

  Future<bool> _isOperationIdIncludedInBlock({required String blockHash, required String operationId}) async {
    await Future.delayed(Duration(seconds: 2));
    final operationHashesList = await rpcInterface.transactionsOperationHashes(level: blockHash);

    return operationHashesList.contains(operationId);
  }

  // Don't delete this, might be useful to compute timeout between chunks
  // Future<Map<String, dynamic>> _constants([chain = 'main', level = 'head']) async {
  //   return _memo['constants'] ??= () async {
  //     final response = await httpClient.get(paths.constants(chain: chain, level: level));

  //     return response.data as Map<String, dynamic>;
  //   }();
  // }

  // Future<Duration> _timeBetweenBlocks([chain = 'main', level = 'head']) async {
  //   return _memo['_timeBetweenBlocks'] ??= () async {
  //     final response = await constants(chain, level);

  //     return Duration(seconds: int.parse(response['time_between_blocks'].first));
  //   }();
  // }
}
