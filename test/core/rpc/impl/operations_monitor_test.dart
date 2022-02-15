import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tezart/src/core/rpc/impl/operations_monitor.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface_paths.dart' as paths;
import 'package:tezart/src/core/rpc/impl/tezart_http_client.dart';

import 'package:tezart/tezart.dart';

import '../../../env/env.dart';
import 'operations_monitor_test.mocks.dart';

@GenerateMocks([RpcInterface, TezartHttpClient])
void main() {
  final rpcInterface = MockRpcInterface();
  const chain = 'main';
  const level = 'head';
  const operationId = 'opId';
  final subject = () => OperationsMonitor(rpcInterface).monitor(chain: chain, level: level, operationId: operationId);

  // Default mocks setup
  const predHash = 'predecessorHash';
  const blockHash = 'blockHash';
  final httpClient = MockTezartHttpClient();

  setUp(() {
    when(rpcInterface.httpClient).thenReturn(httpClient);

    when(rpcInterface.block(chain: chain, level: level)).thenAnswer((_) async {
      return {
        'header': {'predecessor': predHash}
      };
    });

    when(httpClient.getStream(paths.monitor(chain))).thenAnswer((_) async {
      return Response(
        data: ResponseBody(
          Stream.fromIterable(
            [
              Uint8List.fromList(json.encode({'hash': blockHash}).codeUnits),
            ],
          ),
          200,
        ),
        requestOptions: RequestOptions(path: Env.tezosNodeUrl),
      );
    });
  });

  tearDown(() {
    reset(httpClient);
    reset(rpcInterface);
  });

  group('when the operation is included in the first block', () {
    setUp(() {
      when(rpcInterface.transactionsOperationHashes(level: predHash)).thenAnswer((_) async {
        return ['wrongOperationId'];
      });

      when(rpcInterface.transactionsOperationHashes(level: blockHash)).thenAnswer((_) async {
        return [operationId];
      });
    });

    test('it returns the head block hash', () async {
      final result = await subject();

      expect(result, blockHash);
    });

    test('it calls rpc interface methods in order', () async {
      await subject();

      verifyInOrder([
        rpcInterface.block(chain: chain, level: level),
        rpcInterface.transactionsOperationHashes(level: predHash),
        rpcInterface.httpClient,
        httpClient.getStream(paths.monitor(chain)),
        rpcInterface.transactionsOperationHashes(level: blockHash),
      ]);
      verifyNoMoreInteractions(httpClient);
      verifyNoMoreInteractions(rpcInterface);
    });
  });

  group('when the operation id is included in the predecessor block', () {
    setUp(() {
      when(rpcInterface.transactionsOperationHashes(level: predHash)).thenAnswer((_) async {
        return [operationId];
      });
    });

    test('it returns the predecessor block hash', () async {
      final result = await subject();

      expect(result, predHash);
    });

    test('it calls rpc interface methods in order', () async {
      await subject();

      verifyInOrder([
        rpcInterface.block(chain: chain, level: level),
        rpcInterface.transactionsOperationHashes(level: predHash),
      ]);
      verifyNoMoreInteractions(httpClient);
      verifyNoMoreInteractions(rpcInterface);
    });
  });

  group('when the operation id is not found', () {
    setUp(() {
      when(rpcInterface.transactionsOperationHashes(level: predHash)).thenAnswer((_) async {
        return ['wrongOperationId'];
      });

      when(rpcInterface.transactionsOperationHashes(level: blockHash)).thenAnswer((_) async {
        return ['wrongOperationId'];
      });
    });

    test('it throws a TezartNodeError', () async {
      expect(
        () => subject(),
        throwsA(
          predicate(
            (e) =>
                e is TezartNodeError &&
                e.type == TezartNodeErrorTypes.monitoringTimedOut &&
                MapEquality().equals(
                  e.metadata,
                  {'operationId': operationId},
                ),
          ),
        ),
      );
    });
  });
}
