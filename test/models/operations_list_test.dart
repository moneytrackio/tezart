@Timeout(Duration(seconds: 60))
import 'package:meta/meta.dart';
import 'package:test/test.dart';
import 'package:tezart/tezart.dart';

import '../env/env.dart';
import '../test_utils/test_contract_script.dart';

void main() {
  final tezart = TezartClient(Env.tezosNodeUrl);
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);

  group('#executeAndMonitor', () {
    group('TransactionOperation', () {
      final subject = (Keystore source, String destination, int amount) async {
        final operationsList = await tezart.transferOperation(source: source, destination: destination, amount: amount);
        await operationsList.executeAndMonitor();
        return operationsList;
      };

      final destination = Keystore.random().address;
      final amount = 1;

      group('when the key is revealed', () {
        final source = originatorKeystore;

        test('it transfers the amount from source to destination', () async {
          var beforeTransferBalance = await tezart.getBalance(address: destination);
          final operationsList = await subject(source, destination, amount);
          final afterTransferBalance = await tezart.getBalance(address: destination);

          expect(afterTransferBalance - beforeTransferBalance, equals(amount));
          expect(RegExp(r'^o\w+$').hasMatch(operationsList.result.id), true);
        });

        test('it doesnt add a reveal operation', () async {
          final result = await subject(source, destination, amount);
          expect(result.operations.whereType<RevealOperation>(), isEmpty);
        });

        test('it sets simulationResult correctly', () async {
          final result = await subject(source, destination, amount);
          expect(result.operations.first.simulationResult, isNotNull);
        });
      });

      group('when the key is not revealed', () {
        Keystore source;

        setUp(() async {
          source = Keystore.random();
          final operationsList =
              await tezart.transferOperation(source: originatorKeystore, destination: source.address, amount: 100000);
          await operationsList.executeAndMonitor();
        });

        test('it transfers the amount from source to destination', () async {
          var beforeTransferBalance = await tezart.getBalance(address: destination);
          final operationsList = await subject(source, destination, amount);
          final afterTransferBalance = await tezart.getBalance(address: destination);
          expect(afterTransferBalance - beforeTransferBalance, equals(amount));
          expect(RegExp(r'^o\w+$').hasMatch(operationsList.result.id), true);
        });

        test('it reveals the key', () async {
          await subject(source, destination, amount);
          expect(await tezart.isKeyRevealed(source.address), true);
        });
      });
    });

    group('RevealOperation', () {
      final subject = (Keystore keystore) async {
        final operationsList = tezart.revealKeyOperation(keystore);
        await operationsList.executeAndMonitor();
        return operationsList;
      };

      final transferToDest = (Keystore destinationKeystore) async {
        final operationsList = await tezart.transferOperation(
          source: originatorKeystore,
          destination: destinationKeystore.address,
          amount: 10000,
        );
        await operationsList.executeAndMonitor();
      };

      group('when the key is not revealed', () {
        final keystore = Keystore.random();

        setUp(() async {
          await transferToDest(keystore);
        });

        test('it reveals the key', () async {
          await subject(keystore);
          final isKeyRevealed = await tezart.isKeyRevealed(keystore.address);

          expect(isKeyRevealed, isTrue);
        });
      });

      group('when the key is already revealed', () {
        final keystore = originatorKeystore;

        test('throws an error', () async {
          expect(
              subject(keystore),
              throwsA(predicate(
                  (e) => e is TezartNodeError && e.message == "You're trying to reveal an already revealed key.")));
        });
      });
    });

    group('OriginationOperation', () {
      final balanceAmount = 1;
      final storageLimit = 2570;
      final subject = ({
        @required List<Map<String, dynamic>> code,
        @required Map<String, dynamic> storage,
      }) async {
        final operationsList = await tezart.originateContractOperation(
          source: originatorKeystore,
          balance: balanceAmount,
          code: code,
          storage: storage,
          storageLimit: storageLimit,
        );
        await operationsList.executeAndMonitor();

        return operationsList;
      };

      group('when all inputs are valid', () {
        test('doesnt throw any error', () async {
          // expect(()=> subject(), returnsNormally) fails silently
          await subject(
            code: testContractScript['code'],
            storage: testContractScript['storage'],
          );
        });

        test('it sets contractAddress correctly', () async {
          final operationsList = await subject(
            code: testContractScript['code'],
            storage: testContractScript['storage'],
          );

          expect((operationsList.operations.first as OriginationOperation).contractAddress.startsWith('KT'), true);
        });
      });

      group('when code and storage are invalid', () {
        test('throws an error', () async {
          expect(
              subject(code: [{}], storage: {}),
              throwsA(
                predicate((e) =>
                    e is TezartNodeError &&
                    e.message ==
                        'The simulation of the operation: "origination" failed with error(s) : ill_typed_contract, invalid_expression_kind'),
              ));
        });
      });
    });
  });
}
