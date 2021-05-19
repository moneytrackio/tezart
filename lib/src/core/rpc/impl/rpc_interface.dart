import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:memoize/memoize.dart';
import 'package:tezart/src/core/rpc/impl/operations_monitor.dart';
import 'package:tezart/src/models/operations_list/operations_list.dart';

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

  Future<String> forgeOperations(OperationsList operationsList, [chain = 'main', level = 'head']) async {
    log.info('request for forgeOperations [ chain:$chain, level:$level]');
    var content = {
      'branch': await branch(),
      'contents': operationsList.operations.map((operation) => operation.toJson()).toList(),
    };

    return memo1<Map<String, Object>, Future<String>>((Map<String, Object> content) async {
      final response = await httpClient.post(paths.forgeOperations(chain: chain, level: level), data: content);
      return response.data;
    })(content);
  }

  Future<List<dynamic>> preapplyOperations({
    required OperationsList operationsList,
    required String signature,
    chain = 'main',
    level = 'head',
  }) async {
    log.info('request for preapplyOperations [ chain:$chain, level:$level]');
    final content = [
      {
        'branch': await branch(),
        'contents': operationsList.operations.map((operation) => operation.toJson()).toList(),
        'signature': signature,
        'protocol': await protocol(chain, level),
      }
    ];

    var response = await httpClient.post(
      paths.preapplyOperations(
        chain: chain,
        level: level,
      ),
      data: content,
    );

    // TODO: understand why array ? difference with run ??
    return response.data.first['contents'];
  }

  Future<List<dynamic>> runOperations(OperationsList operationsList, [chain = 'main', level = 'head']) async {
    log.info('request for runOperations [ chain:$chain, level:$level]');
    var content = {
      'operation': {
        'branch': await branch(),
        'contents': operationsList.operations.map((operation) => operation.toJson()).toList(),
        'signature': randomSignature
      },
      'chain_id': await chainId()
    };

    var response = await httpClient.post(paths.runOperations(chain: chain, level: level), data: content);

    return response.data['contents'];
  }

  Future<String?> managerKey(String address, [chain = 'main', level = 'head']) async {
    log.info('request for managerKey [ chain:$chain, level:$level]');
    var response = await httpClient.get(paths.managerKey(address: address, chain: chain, level: level));

    return response.data;
  }

  Future<int> balance(String address, [chain = 'main', level = 'head']) async {
    log.info('request for balance [ chain:$chain, level:$level]');
    var response = await httpClient.get(paths.balance(chain: chain, level: level, address: address));

    return int.parse(response.data['balance']);
  }

  Future<Map<String, dynamic>> getContract(String address, [chain = 'main', level = 'head']) async {
    log.info('request for contract : $address');

    var response = await httpClient.get(paths.contract(chain: chain, level: level, contractAddress: address));

    return response.data;
  }

  Future<Map<String, dynamic>> getContractEntrypoints(String address, [chain = 'main', level = 'head']) async {
    log.info('request for contract entrypoints : $address');

    return memo1<String, Future<Map<String, dynamic>>>((String address) async {
      var response = await httpClient.get(paths.contractEntrypoints(
        chain: chain,
        level: level,
        contractAddress: address,
      ));

      return response.data['entrypoints'];
    })(address);
  }

  Future<Map<String, dynamic>> getContractEntrypointSchema({
    required String address,
    required String entrypoint,
    chain = 'main',
    level = 'head',
  }) async {
    log.info('request for contract : $address, entrypoint: $entrypoint');

    return memo2<String, String, Future<Map<String, dynamic>>>((String address, String entrypoint) async {
      var response = await httpClient.get(paths.contractEntrypoint(
        chain: chain,
        level: level,
        contractAddress: address,
        entrypoint: entrypoint,
      ));

      return response.data;
    })(address, entrypoint);
  }

  Future<List<String>> transactionsOperationHashes({
    required String level,
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
    required String operationId,
    chain = 'main',
    level = 'head',
  }) async {
    return operationsMonitor.monitor(chain: chain, level: level, operationId: operationId);
  }

  OperationsMonitor get operationsMonitor => memo0(() => OperationsMonitor(this))();

  Future<Map<String, dynamic>> block({required String chain, required String level}) async {
    final response = await httpClient.get(paths.block(chain: chain, level: level));

    return response.data;
  }

  Future<Map<String, dynamic>> constants([chain = 'main', level = 'head']) async {
    return memo2<String, String, Future<Map<String, dynamic>>>((String chain, String level) async {
      log.info('request to constants');
      final response = await httpClient.get(paths.constants(chain: chain, level: level));

      return response.data;
    })(chain, level);
  }

  Future<String> pack({
    required dynamic data, // in micheline
    required Map<String, dynamic> type,
    chain = 'main',
    level = 'head',
  }) async {
    final content = {
      'data': data,
      'type': type,
    };
    final response = await httpClient.post(paths.pack(chain: chain, level: level), data: content);

    return response.data['packed'];
  }

  Future bigMapValue({
    required String id,
    required String encodedScriptExpression,
    chain = 'main',
    level = 'head',
  }) async {
    final response = await httpClient.get(paths.bigMapValue(
      level: level,
      chain: chain,
      id: id,
      encodedScriptExpression: encodedScriptExpression,
    ));

    return response.data;
  }
}
