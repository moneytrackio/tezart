import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:memoize/memoize.dart';
import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/impl/operations_monitor.dart';
import 'package:tezart/src/models/operation/operation.dart';

import 'tezart_http_client.dart';
import 'rpc_interface_paths.dart' as paths;

class RpcInterface {
  static const randomSignature =
      'edsigu165B7VFf3Dpw2QABVzEtCxJY2gsNBNcE3Ti7rRxtDUjqTFRpg67EdAQmY6YWPE5tKJDMnSTJDFu65gic8uLjbW2YwGvAZ';
  final TezartHttpClient httpClient;
  final log = Logger('RpcInterface');

  RpcInterface(String url) : httpClient = TezartHttpClient(url);

  Future<String> branch([chain = 'main', level = 'head']) async {
    log.info('request for branch [ chain:$chain, level:$level]');
    var response = await httpClient.get(paths.branch(chain: chain, level: level));

    return response.data;
  }

  Future<String> chainId([chain = 'main']) async {
    log.info('request for chainId [ chain:$chain ]');
    var response = await httpClient.get(paths.chainId(chain));

    return response.data;
  }

  Future<String> protocol([chain = 'main', level = 'head']) async {
    log.info('request for protocol [ chain:$chain, level:$level]');
    var response = await httpClient.get(paths.protocol(chain: chain, level: level));

    return response.data['protocol'];
  }

  Future<int> counter(String source, [chain = 'main', level = 'head']) async {
    log.info('request for counter [ chain:$chain, level:$level]');
    final response = await httpClient.get(paths.counter(source: source, chain: chain, level: level));

    return int.parse(response.data);
  }

  Future<Map<String, dynamic>> pendingOperations([chain = 'main']) async {
    log.info('request for pendingOperations [ chain:$chain]');
    final response = await httpClient.get(paths.pendingOperations(chain));

    return response.data;
  }

  Future<String> injectOperation(String data, [chain = 'main']) async {
    log.info('request for injectOperation [ chain:$chain]');
    final response = await httpClient.post(paths.injectOperation(chain), data: jsonEncode(data));

    return response.data;
  }

  Future<String> forgeOperations(List<Operation> operations, [chain = 'main', level = 'head']) async {
    log.info('request for forgeOperations [ chain:$chain, level:$level]');
    var content = {
      'branch': await branch(),
      'contents': operations.map((operation) => operation.toJson()).toList(),
    };
    var response = await httpClient.post(paths.forgeOperations(chain: chain, level: level), data: content);

    return response.data;
  }

  Future<List<dynamic>> preapplyOperations({
    List<Operation> operations,
    String signature,
    chain = 'main',
    level = 'head',
  }) async {
    log.info('request for preapplyOperations [ chain:$chain, level:$level]');
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

  Future<List<dynamic>> runOperations(List<Operation> operations, [chain = 'main', level = 'head']) async {
    log.info('request for runOperations [ chain:$chain, level:$level]');
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
    log.info('request for managerKey [ chain:$chain, level:$level]');
    var response = await httpClient.get(paths.managerKey(address: address, chain: chain, level: level));

    return response.data;
  }

  Future<int> balance(String address, [chain = 'main', level = 'head']) async {
    log.info('request for balance [ chain:$chain, level:$level]');
    var response = await httpClient.get(paths.balance(chain: chain, level: level, address: address));

    return int.parse(response.data['balance']);
  }

  Future<List<String>> transactionsOperationHashes({
    @required String level,
    chain = 'main',
  }) async {
    final response = await httpClient.get(paths.operationHashes(
      chain: chain,
      level: level,
      offset: 3,
    ));
    return response.data.cast<String>().toList();
  }

  // TODO: wait for multiple blocks
  Future<String> monitorOperation({
    @required String operationId,
    chain = 'main',
    level = 'head',
  }) async {
    return operationsMonitor.monitor(chain: chain, level: level, operationId: operationId);
  }

  OperationsMonitor get operationsMonitor => memo0(() => OperationsMonitor(this))();

  Future<Map<String, dynamic>> block({@required String chain, @required String level}) async {
    final response = await httpClient.get(paths.block(chain: chain, level: level));

    return response.data;
  }
}
