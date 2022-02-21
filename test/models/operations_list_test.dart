// ignore_for_file: prefer_function_declarations_over_variables

@Timeout(Duration(seconds: 60))
@Tags(["unstable"])

import 'package:test/test.dart';
import 'package:tezart/tezart.dart';

import '../env/env.dart';
import '../test_utils/test_contract_script.dart';
import '../test_utils/test_client.dart';

void main() {
  final tezart = testClient();
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);

  group('#executeAndMonitor', () {
    group('TransactionOperation', () {
      final subject = (Keystore source, String destination, int amount) async {
        final operationsList = await tezart.transferOperation(source: source, destination: destination, amount: amount);
        await operationsList.executeAndMonitor();
        return operationsList;
      };

      final amount = 10;
      late String destination;

      setUp(() {
        destination = Keystore.random().address;
      });

      group('when the source key is revealed', () {
        final source = originatorKeystore;

        test('it transfers the amount from source to destination', () async {
          var beforeTransferBalance = await tezart.getBalance(address: destination);
          final operationsList = await subject(source, destination, amount);
          final afterTransferBalance = await tezart.getBalance(address: destination);

          expect(afterTransferBalance - beforeTransferBalance, equals(amount));
          expect(RegExp(r'^o\w+$').hasMatch(operationsList.result.id!), true);
        });

        test('it doesnt add a reveal operation', () async {
          final result = await subject(source, destination, amount);
          expect(result.operations.whereType<RevealOperation>(), isEmpty);
        });

        test('it sets simulationResult correctly', () async {
          final result = await subject(source, destination, amount);
          expect(result.operations.first.simulationResult, isNotNull);
        });

        test('it sets limits correctly', () async {
          final result = await subject(source, destination, amount);
          final operation = result.operations.first;

          expect(operation.gasLimit, 1520);
          expect(operation.storageLimit, 257);
          // can't test equality because there might be a difference of ~= 5 µtz because of the forged operation size difference
          expect(operation.fee, lessThan(64656));
        });
      });

      group('when the source key is not revealed', () {
        late Keystore source;

        setUp(() async {
          source = Keystore.random();
          final operationsList =
              await tezart.transferOperation(source: originatorKeystore, destination: source.address, amount: 1000000);
          await operationsList.executeAndMonitor();
        });

        test('it transfers the amount from source to destination', () async {
          var beforeTransferBalance = await tezart.getBalance(address: destination);
          final operationsList = await subject(source, destination, amount);
          final afterTransferBalance = await tezart.getBalance(address: destination);
          expect(afterTransferBalance - beforeTransferBalance, equals(amount));
          expect(RegExp(r'^o\w+$').hasMatch(operationsList.result.id!), true);
        });

        test('it reveals the key', () async {
          await subject(source, destination, amount);
          expect(await tezart.isKeyRevealed(source.address), true);
        });

        test('it sets limits correctly', () async {
          final result = await subject(source, destination, amount);
          final revealOperation = result.operations.first;
          final transactionOperation = result.operations[1];

          expect(revealOperation.gasLimit, 1100);
          expect(revealOperation.storageLimit, 0);
          // can't test equality because there might be a difference of ~= 5 µtz because of the forged operation size difference
          expect(revealOperation.fee, lessThan(320));

          expect(transactionOperation.gasLimit, 1520);
          expect(transactionOperation.storageLimit, 257);
          // can't test equality because there might be a difference of ~= 5 µtz because of the forged operation size difference
          expect(transactionOperation.fee, lessThan(64612));
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
        late Keystore keystore;

        setUp(() {
          keystore = Keystore.random();
        });

        setUp(() async {
          await transferToDest(keystore);
        });

        test('it reveals the key', () async {
          await subject(keystore);
          final isKeyRevealed = await tezart.isKeyRevealed(keystore.address);

          expect(isKeyRevealed, isTrue);
        });

        test('it sets limits correctly', () async {
          final result = await subject(keystore);
          final revealOperation = result.operations.first;

          expect(revealOperation.gasLimit, 1100);
          expect(revealOperation.storageLimit, 0);
          // can't test equality because there might be a difference of ~= 5 µtz because of the forged operation size difference
          expect(revealOperation.fee, lessThan(372));
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
      final subject = ({
        required List<Map<String, dynamic>> code,
        required dynamic storage,
      }) async {
        final operationsList = await tezart.originateContractOperation(
          source: originatorKeystore,
          balance: balanceAmount,
          code: code,
          storage: storage,
        );
        await operationsList.executeAndMonitor();

        return operationsList;
      };

      group('when all inputs are valid', () {
        test('doesnt throw any error', () async {
          // expect(()=> subject(), returnsNormally) fails silently
          await subject(
            code: testContractScript,
            storage: {'int': '12'},
          );
        });

        test('it sets contractAddress correctly', () async {
          final operationsList = await subject(
            code: testContractScript,
            storage: {'int': '12'},
          );

          final contractAddress = (operationsList.operations.first as OriginationOperation).contractAddress;

          expect(contractAddress.startsWith('KT'), true);
        });

        test('it sets limits correctly', () async {
          final result = await subject(
            code: testContractScript,
            storage: {'int': '12'},
          );
          final originationOperation = result.operations.first;

          expect(originationOperation.gasLimit, 1505);
          expect(originationOperation.storageLimit, 295);
          // can't test equality because there might be a difference of ~= 5 µtz because of the forged operation size difference
          expect(originationOperation.fee, lessThan(74171));
        });
      });

      group('when code and storage are invalid', () {
        test('throws an error', () async {
          expect(
              subject(code: [{}], storage: {}),
              throwsA(predicate((e) =>
                  e is TezartNodeError &&
                  RegExp(r'ill_typed_contract.*invalid_expression_kind.*$').hasMatch(e.message))));
        });
      });
    });
  });
}
