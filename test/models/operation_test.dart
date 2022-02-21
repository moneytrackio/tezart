// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/tezart.dart';

void main() {
  final rpcInterface = RpcInterface('http://localhost:20000');
  const kind = Kinds.generic;
  final source = Keystore.fromSeed('edsk4CCa2afKwHWGxB5oZd4jvhq6tgd5EzFaryyR4vLdC3nvpjKUG6');
  final publicKey = source.publicKey;
  const destination = 'tz1Q9L8us1DWMNDCyPcaScghH9fcgUSD1zFy';
  const amount = 1;
  const balance = 1;
  const counter = 543;
  final parameters = {'first': 'parameter', 'second': 'parameter'};
  final fee = 1;
  final gasLimit = 10;
  final storageLimit = 100;
  final operationsList = OperationsList(source: source, rpcInterface: rpcInterface);

  group('#toJson()', () {
    test('returns valid Json when including public_key when the kind is revealall fields are present', () {
      final operation = Operation(
        kind: Kinds.reveal,
        destination: destination,
        balance: balance,
        amount: amount,
        params: parameters,
      )
        ..operationsList = operationsList
        ..gasLimit = gasLimit
        ..storageLimit = storageLimit
        ..fee = fee
        ..counter = counter;

      final expectedResult = {
        'kind': 'reveal',
        'source': source.address,
        'destination': destination,
        'public_key': publicKey,
        'balance': balance.toString(),
        'amount': amount.toString(),
        'counter': counter.toString(),
        'fee': fee.toString(),
        'gas_limit': gasLimit.toString(),
        'storage_limit': storageLimit.toString(),
        'parameters': {'value': parameters},
      };

      expect(operation.toJson(), equals(expectedResult));
    });

    test('returns valid Json when publicKey is missing', () {
      final operation = Operation(
        kind: kind,
        destination: destination,
        amount: amount,
        params: parameters,
      )
        ..operationsList = operationsList
        ..counter = counter;

      expect(operation.toJson().keys, isNot(contains('public_key')));
    });

    test('returns valid Json when amount is missing', () {
      final operation = Operation(
        kind: kind,
        destination: destination,
        params: parameters,
      )
        ..operationsList = operationsList
        ..counter = counter;

      expect(operation.toJson().keys, isNot(contains('amount')));
    });

    test('returns valid Json when parameters is missing', () {
      final operation = Operation(
        kind: kind,
        destination: destination,
        amount: amount,
      )
        ..operationsList = operationsList
        ..counter = counter;

      expect(operation.toJson().keys, isNot(contains('parameters')));
    });
  });

  group('#simulationResult=', () {
    final subject = (Map<String, dynamic> simulationResult) {
      final operation = Operation(
        kind: kind,
        destination: destination,
        amount: amount,
        params: parameters,
      )
        ..operationsList = operationsList
        ..counter = counter;
      operation.simulationResult = simulationResult;
    };

    group('when the simulation fails', () {
      final simulationResult = {
        'kind': 'origination',
        'metadata': {
          'operation_result': {
            'status': 'failed',
            'errors': [
              {
                'id': 'proto.error1',
              },
              {
                'id': 'proto.error2',
              },
            ],
          },
        },
      };

      test('throws an error', () {
        expect(() => subject(simulationResult),
            throwsA(predicate((e) => e is TezartNodeError && e.type == TezartNodeErrorTypes.simulationFailed)));
      });
    });
  });
}
