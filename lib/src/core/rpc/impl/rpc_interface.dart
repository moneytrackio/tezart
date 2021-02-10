import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:tezart/src/core/client/tezart_client.dart';
import 'package:tezart/src/models/operation/operation.dart';
import 'package:tezart/src/common/utils/list_utils.dart';

import 'tezart_http_client.dart';
import 'rpc_interface_paths.dart' as paths;

class RpcInterface {
  static const randomSignature =
      'edsigu165B7VFf3Dpw2QABVzEtCxJY2gsNBNcE3Ti7rRxtDUjqTFRpg67EdAQmY6YWPE5tKJDMnSTJDFu65gic8uLjbW2YwGvAZ';
  final TezartHttpClient httpClient;

  RpcInterface({@required String host, String port = '80', String scheme = 'http'})
      : httpClient = TezartHttpClient(host: host, port: port, scheme: scheme);

  Future<String> branch([chain = 'main', level = 'head']) async {
    var response = await httpClient.get(paths.branch(chain: chain, level: level));

    return response.data;
  }

  Future<String> chainId([chain = 'main']) async {
    var response = await httpClient.get(paths.chainId(chain));

    return response.data;
  }

  Future<String> protocol([chain = 'main', level = 'head']) async {
    var response = await httpClient.get(paths.protocol(chain: chain, level: level));

    return response.data['protocol'];
  }

  Future<int> counter(String source, [chain = 'main', level = 'head']) async {
    final response = await httpClient.get(paths.counter(source: source, chain: chain, level: level));

    return int.parse(response.data);
  }

  Future<Map<String, dynamic>> pendingOperations([chain = 'main']) async {
    final response = await httpClient.get(paths.pendingOperations(chain));

    return response.data;
  }

  Future<String> injectOperation(String data, [chain = 'main']) async {
    final response = await httpClient.post(paths.injectOperation(chain), data: jsonEncode(data));

    return response.data;
  }

  Future<String> forgeOperations(List<Operation> operations, [chain = 'main', level = 'head']) async {
    var content = {
      'branch': await branch(),
      'contents': operations.map((operation) => operation.toJson()).toList(),
    };
    var response = await httpClient.post(paths.forgeOperations(chain: chain, level: level), data: content);

    return response.data;
  }

  Future<List<dynamic>> runOperations(List<Operation> operations, [chain = 'main', level = 'head']) async {
    var content = {
      'operation': {
        'branch': await branch(),
        'contents': operations.map((operation) => operation.toJson()).toList(),
        'signature': randomSignature
      },
      'chain_id': await chainId()
    };

    var response = await httpClient.post(paths.runOperations(chain: chain, level: level), data: content);

    return response.data['contents'];
  }

  Future<String> managerKey(String address, [chain = 'main', level = 'head']) async {
    var response = await httpClient.get(paths.managerKey(address: address, chain: chain, level: level));

    return response.data;
  }

  Future<int> balance(String address, [chain = 'main', level = 'head']) async {
    var response = await httpClient.get(paths.balance(chain: chain, level: level, address: address));

    return int.parse(response.data['balance']);
  }

  Future<List<String>> operationHashes(String level, [chain = 'main']) async {
    final response = await httpClient.get(paths.operationHashes(chain: chain, level: level));
    final unflattenedData = response.data as List;
    final operationHashes = ListUtils.flatten<String>(unflattenedData);

    return operationHashes;
  }

  // TODO: handle timeout
  // TODO: wait for multiple blocks
  Future<void> monitorOperation({
    @required String operationId,
    @required Duration timeBetweenBlocks,
    chain = 'main',
  }) async {
    final startTime = DateTime.now();
    final timeout = timeBetweenBlocks * 2;
    final rs = await httpClient.getStream(paths.monitor(chain));

    await for (var value in rs.data.stream) {
      final blockHash = json.decode(String.fromCharCodes(value))['hash'];
      final operationHashesList = await operationHashes(blockHash);
      final currentTime = DateTime.now();

      if (operationHashesList.contains(operationId)) return;
      if (currentTime.difference(startTime) > timeout) {
        throw TezartNodeError(
          type: TezartNodeErrorTypes.monitoring_timed_out,
          metadata: {'operationId': operationId},
        );
      }
    }
  }
}
