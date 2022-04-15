// ignore_for_file: prefer_function_declarations_over_variables

@Tags(["unstable"])
@Timeout(Duration(seconds: 60))

import 'package:test/test.dart';
import 'package:tezart/tezart.dart';

import '../../env/env.dart';
import '../../test_utils/test_contract_script.dart';
import '../../test_utils/test_client.dart';

void main() {
  final tezart = testClient();
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);

  group('#transferOperation', () {
    final subject = (Keystore source, String destination, int amount) =>
        tezart.transferOperation(source: source, destination: destination, amount: amount);
    final destination = Keystore.random().address;
    final amount = 1;

    group('when the key is revealed', () {
      final source = originatorKeystore;

      test('it doesnt prepend the reveal operation', () async {
        final operationsList = await subject(source, destination, amount);
        expect(operationsList.operations.whereType<RevealOperation>(), isEmpty);
      });

      test('it contains a valid transaction operation', () async {
        final operationsList = await subject(source, destination, amount);
        expect(operationsList.operations.length, 1);
        expect(operationsList.operations.first, isA<TransactionOperation>());
      });
    });

    group('when the key is not revealed', () {
      late Keystore source;

      setUp(() async {
        source = Keystore.random();
      });

      test('it prepends the reveal operation', () async {
        final operationsList = await subject(source, destination, amount);
        expect(operationsList.operations.first, isA<RevealOperation>());
      });

      test('it contains a valid transaction operation', () async {
        final operationsList = await subject(source, destination, amount);
        expect(operationsList.operations.length, 2);
        expect(operationsList.operations[1], isA<TransactionOperation>());
      });
    });
  });

  group('#isKeyRevealed', () {
    final subject = (String address) => tezart.isKeyRevealed(address);

    group('when the key is not revealed', () {
      final address = Keystore.random().address;

      test('it returns false', () async {
        final result = await subject(address);

        expect(result, isFalse);
      });
    });

    group('when the key is revealed', () {
      final address = originatorKeystore.address;

      test('it returns true', () async {
        final result = await subject(address);

        expect(result, isTrue);
      });
    });
  });

  group('#revealKey', () {
    final subject = (Keystore keystore) => tezart.revealKeyOperation(keystore);

    final keystore = Keystore.random();

    test('the operations list contains a reveal operation only', () {
      final operationsList = subject(keystore);

      expect(operationsList.operations.length, 1);
      expect(operationsList.operations.first, isA<RevealOperation>());
    });
  });

  group('#monitorOperation', () {
    final subject = (String operationId) async => tezart.monitorOperation(operationId);

    group('when the operationId exists', () {
      test('it monitors the operation', () async {
        final getBalance = () => tezart.getBalance(address: originatorKeystore.address);
        final destination = Keystore.random();
        final amount = 1;
        final balanceBeforeTransfer = await getBalance();
        final operationsList = await tezart.transferOperation(
          source: originatorKeystore,
          destination: destination.address,
          amount: amount,
        );
        await operationsList.execute();
        await subject(operationsList.result.id!);
        final balanceAfterMonitoring = await getBalance();

        expect(balanceAfterMonitoring, lessThan(balanceBeforeTransfer));
      });
    });

    group('when the operationId doesnt exist', () {
      test('it throws an error', () async {
        final operationId = 'toto';
        expect(
            () => subject(operationId),
            throwsA(predicate(
                (e) => e is TezartNodeError && e.message == 'Monitoring the operation $operationId timed out')));
      });
    });
  });

  group('#originateContract', () {
    final balanceAmount = 1;
    final subject = (Keystore source) => tezart.originateContractOperation(
          source: source,
          balance: balanceAmount,
          code: testContractScript,
          storage: {'int': '12'},
        );

    group('when the source key is already revealed', () {
      test('it returns an operations list containing an OriginationOperation only', () async {
        final operationsList = await subject(originatorKeystore);
        expect(operationsList.operations.length, 1);
        expect(operationsList.operations.first, isA<OriginationOperation>());
      });
    });

    group('when the source key is not revealed', () {
      test('it prepends the operations list with a reveal operation', () async {
        final operationsList = await subject(Keystore.random());
        expect(operationsList.operations.first, isA<RevealOperation>());
      });

      test('it returns an operations list containing an origination operation in the second place', () async {
        final operationsList = await subject(Keystore.random());
        expect(operationsList.operations.length, 2);
        expect(operationsList.operations[1], isA<OriginationOperation>());
      });
    });
  });
}
