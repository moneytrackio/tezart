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

  final originateContract = (List<Map<String, dynamic>> code, dynamic storage) async {
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

  group('#fetch', () {
    late Contract contract;

    group('when the contract storage is a big map', () {
      setUp(() async {
        await originateContract(bigMapContract, []);
        contract = Contract(contractAddress: contractAddress, rpcInterface: rpcInterface);
        final operationsList = await contract.callOperation(
          source: source,
          params: {'my_key': 'key', 'my_val': 'val'},
        );
        await operationsList.executeAndMonitor();
      });

      final subject = (String key) async {
        final BigMap bigMap = (await contract.storage);
        return bigMap.fetch(key: key, rpcInterface: rpcInterface);
      };

      group('when the key exists', () {
        test('it returns the value', () async {
          expect(await subject('key'), 'val');
        });
      });

      group('when the key doesnt exist', () {
        test('it throws an error', () async {
          expect(subject('unexistant'), throwsA(predicate((e) => e is TezartHttpError && e.message == 'Not Found')));
        });
      });
    });

    group('when the contract storage contains multiple structures', () {
      setUp(() async {
        await originateContract(multipleStructuresContract, {
          'prim': 'Pair',
          'args': [
            [],
            {
              'prim': 'Pair',
              'args': [[], []]
            }
          ]
        });
        contract = Contract(contractAddress: contractAddress, rpcInterface: rpcInterface);
        final operationsList = await contract.callOperation(
          source: source,
          params: {'my_key': 'key', 'my_val': 'val'},
        );
        await operationsList.executeAndMonitor();
      });

      final subject = (String key) async {
        final BigMap bigMap = (await contract.storage)['my_big_map'];
        return bigMap.fetch(key: key, rpcInterface: rpcInterface);
      };

      test('it returns the value', () async {
        expect(await subject('key'), 'val');
      });
    });
  });
}
