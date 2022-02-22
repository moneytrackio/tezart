// ignore_for_file: prefer_function_declarations_over_variables
@Tags(["unstable"])

import 'package:test/test.dart';
import 'package:tezart/tezart.dart';

import '../env/env.dart';
import '../test_utils/test_contract_script.dart';
import '../test_utils/test_client.dart';

void main() {
  final tezart = testClient();
  final rpcInterface = tezart.rpcInterface;
  final source = Keystore.fromSecretKey(Env.originatorSk);
  const balance = 10;
  late String contractAddress;

  final originateContractSetUp = (List<Map<String, dynamic>> code, dynamic storage) async {
    final operationsList = await tezart.originateContractOperation(
      source: source,
      code: code,
      storage: storage,
      balance: balance,
    );
    await operationsList.executeAndMonitor();
    final originationOperation = operationsList.operations.last as OriginationOperation;
    contractAddress = originationOperation.contractAddress;
  };

  group('#balance', () {
    final subject = () => Contract(
          contractAddress: contractAddress,
          rpcInterface: rpcInterface,
        ).balance;

    group('when the contract exists', () {
      setUp(() async {
        await originateContractSetUp(storeValueContract, {'int': '12'});
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
        expect(() => subject(), throwsA(predicate((e) => e is TezartHttpError && e.message == 'Not Found')));
      });
    });
  });

  group('#storage', () {
    final subject = () => Contract(
          contractAddress: contractAddress,
          rpcInterface: rpcInterface,
        ).storage;

    group('when the contract address exists', () {
      group('when the contract has a storage', () {
        setUp(() async {
          await originateContractSetUp(storeValueContract, {'int': '12'});
        });

        test('it returns the storage of the contract', () async {
          expect(await subject(), 12);
        });
      });

      group('when the contrat has no storage', () {
        setUp(() async {
          await originateContractSetUp(noStorageContract, {'prim': 'Unit'});
        });

        test('it returns null', () async {
          expect(await subject(), null);
        });
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
        await originateContractSetUp(storeValueContract, {'int': '12'});
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

  group('#multiparams_entrypoints', () {
    final subject = () => Contract(
          contractAddress: contractAddress,
          rpcInterface: rpcInterface,
        ).entrypoints;

    group('when the contract address exists', () {
      late Contract contract;

      setUp(() async {
        await originateContractSetUp(demoContract, {
          'prim': 'Pair',
          'args': [[], []]
        });
        contract = Contract(contractAddress: contractAddress, rpcInterface: rpcInterface);
      });

      test('it returns the entrypoints of the contract', () async {
        expect(await subject(), ['always_fail', 'add_third', 'add_second', 'add_first']);
      });
      group('#callOperation', () {
        final subject = (dynamic params, String entrypoint) async {
          final operationsList = await contract.callOperation(source: source, entrypoint: entrypoint, params: params);
          await operationsList.executeAndMonitor();
        };

        group('when the params are valid', () {
          final params = {'first': '1', 'second': '2', 'third': '3', 'key': 'key'};
          final entrypoint = 'add_third';

          test('it updates the storage value correctly', () async {
            await subject(params, entrypoint);
            final storage = (await contract.storage);
            final BigMap bigMap = storage['big_map_second'];
            final value = await bigMap.fetch(key: 'key', rpcInterface: rpcInterface);

            expect(value, '123');
          });
        });
      });
    });
  });

  group('#callOperation', () {
    late Contract contract;

    setUp(() async {
      await originateContractSetUp(storeValueContract, {'int': '12'});
      contract = Contract(contractAddress: contractAddress, rpcInterface: rpcInterface);
    });

    final subject = (dynamic params, String entrypoint) async {
      final operationsList = await contract.callOperation(source: source, entrypoint: entrypoint, params: params);
      await operationsList.executeAndMonitor();
    };

    group('when the params are valid', () {
      final params = 15;
      final entrypoint = 'replace';

      test('it updates the storage value correctly', () async {
        await subject(params, entrypoint);

        expect(await contract.storage, 15);
      });
    });

    group('when the entrypoint doesnt exist', () {
      final params = 15;
      final entrypoint = 'not_found';

      test('it throws a simulationFailed error', () async {
        expect(() => subject(params, entrypoint),
            throwsA(predicate((e) => e is TezartHttpError && e.message == 'Not Found')));
      });
    });

    group('when the params are invalid', () {
      group('when the params are incompatible with the entrypoint signature', () {
        final entrypoint = 'replace';
        final params = {'string': 'value'};

        test('it throws a simulationFailed error', () async {
          // TODO: throw custom error instead ?
          expect(() => subject(params, entrypoint), throwsA(predicate((e) => e is TypeError)));
        });
      });

      group('when the params cause a runtime error', () {
        final entrypoint = 'divide';
        final params = 2;

        test('it throws a simulationFailed error', () async {
          // the error is caused because params.divisor < 5 (c.f contract)
          expect(() => subject(params, entrypoint),
              throwsA(predicate((e) => e is TezartNodeError && e.type == TezartNodeErrorTypes.simulationFailed)));
        });
      });
    });
  });
}
