import 'package:test/test.dart';
import 'package:tezart/src/contracts/contract.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/tezart.dart';

import '../env/env.dart';
import '../test_utils/test_contract_script.dart';

void main() {
  final tezart = TezartClient(Env.tezosNodeUrl);
  final rpcInterface = tezart.rpcInterface;
  final source = Keystore.fromSecretKey(Env.originatorSk);
  const balance = 10;
  late String contractAddress;

  final originateContractSetUp = () async {
    final operationsList = await tezart.originateContractOperation(
      source: source,
      code: storeValueContract['code'],
      storage: storeValueContract['storage'],
      balance: balance,
    );
    await operationsList.executeAndMonitor();
    final originationOperation = operationsList.operations.last as OriginationOperation;
    contractAddress = await originationOperation.contractAddress;
  };

  group('#balance', () {
    final subject = () => Contract(
          contractAddress: contractAddress,
          rpcInterface: rpcInterface,
        ).balance;

    group('when the contract exists', () {
      setUp(() async {
        await originateContractSetUp();
      });

      test('it returns the balance of the contract', () async {
        expect(await subject(), balance);
      });
    });

    group('when the contract address doesnt exist', () {
      setUp(() {
        contractAddress = 'KT1MkEVtQRWU6Lz5buqsZc5sdXbwprc1ep9b';
      });

      test('it throws an error', () {
        // TODO: throw TezartNodeError or ContractError ?
        expect(() => subject(), throwsA(predicate((e) => e is TezartHttpError)));
      });
    });
  });

  group('#storage', () {
    final subject = () => Contract(
          contractAddress: contractAddress,
          rpcInterface: rpcInterface,
        ).storage;

    group('when the contract address exists', () {
      setUp(() async {
        await originateContractSetUp();
      });

      test('it returns the storage of the contract', () async {
        expect(await subject(), {'int': '12'});
      });
    });

    group('when the contract address doesnt exist', () {
      setUp(() {
        contractAddress = 'KT1MkEVtQRWU6Lz5buqsZc5sdXbwprc1ep9b';
      });

      test('it throws an error', () {
        // TODO: throw TezartNodeError or ContractError ?
        expect(() => subject(), throwsA(predicate((e) => e is TezartHttpError)));
      });
    });
  });

  group('#entrypoints', () {
    final subject = () => Contract(
          contractAddress: contractAddress,
          rpcInterface: rpcInterface,
        ).entrypoints;

    group('when the contract address exists', () {
      setUp(() async {
        await originateContractSetUp();
      });

      test('it returns the entrypoints of the contract', () async {
        expect(await subject(), ['replace', 'double', 'divide']);
      });
    });

    group('when the contract address doesnt exist', () {
      setUp(() {
        contractAddress = 'KT1MkEVtQRWU6Lz5buqsZc5sdXbwprc1ep9b';
      });

      test('it throws an error', () {
        // TODO: throw TezartNodeError or ContractError ?
        expect(() => subject(), throwsA(predicate((e) => e is TezartHttpError)));
      });
    });
  });

  group('#callOperation', () {
    late Contract contract;

    setUp(() async {
      await originateContractSetUp();
      contract = Contract(contractAddress: contractAddress, rpcInterface: rpcInterface);
    });

    final subject = (Map<String, dynamic> params, String entrypoint) async {
      final operationsList = contract.callOperation(source: source, entrypoint: entrypoint, params: params);
      await operationsList.executeAndMonitor();
    };

    group('when the params are valid', () {
      final params = {'int': '15'};
      final entrypoint = 'replace';

      test('it updates the storage value correctly', () async {
        await subject(params, entrypoint);

        expect(await contract.storage, {'int': '15'});
      });
    });

    group('when the entrypoint doesnt exist', () {
      final params = {'int': '15'};
      final entrypoint = 'not_found';

      test('it throws a simulationFailed error', () async {
        expect(() => subject(params, entrypoint),
            throwsA(predicate((e) => e is TezartNodeError && e.type == TezartNodeErrorTypes.simulationFailed)));
      });
    });

    group('when the params are invalid', () {
      group('when the params are invalid micheline', () {
        final entrypoint = 'replace';
        final params = {'invalid': 'micheline'};

        test('it throws an unhandled error', () async {
          expect(
              () => subject(params, entrypoint),
              throwsA(predicate((e) =>
                  e is TezartNodeError &&
                  RegExp(r'Unhandled error: Failed to parse the request body: No case matched.*')
                      .hasMatch(e.message))));
        });
      });

      group('when the params are incompatible with the entrypoint signature', () {
        final entrypoint = 'replace';
        final params = {'string': 'value'};

        test('it throws a simulationFailed error', () async {
          expect(() => subject(params, entrypoint),
              throwsA(predicate((e) => e is TezartNodeError && e.type == TezartNodeErrorTypes.simulationFailed)));
        });
      });

      group('when the params generate a runtime error', () {
        final entrypoint = 'divide';
        final params = {
          'prim': 'Left',
          'args': [
            {'int': '2'}
          ]
        };

        test('it throws a simulationFailed error', () async {
          // the error is caused because params.divisor < 5 (c.f contract)
          expect(() => subject(params, entrypoint),
              throwsA(predicate((e) => e is TezartNodeError && e.type == TezartNodeErrorTypes.simulationFailed)));
        });
      });
    });
  });
}
