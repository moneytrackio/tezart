@Timeout(Duration(seconds: 60))

import 'package:test/test.dart';
import 'package:tezart/tezart.dart';

import '../../env/env.dart';
// TODO: uncomment for originateContract tests
// import '../../test_utils/test_contract_script.dart';

void main() {
  final tezart = TezartClient(Env.tezosNodeUrl);
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);

  group('#transfer', () {
    final subject = (Keystore source, String destination, int amount) =>
        tezart.transfer(source: source, destination: destination, amount: amount);
    final destination = Keystore.random().address;
    final amount = 1;

    group('when the key is revealed', () {
      final source = originatorKeystore;

      test('it transfers the amount from source to destination', () async {
        var beforeTransferBalance = await tezart.getBalance(address: destination);
        final operationsList = await subject(source, destination, amount);
        await operationsList.monitor();
        final afterTransferBalance = await tezart.getBalance(address: destination);

        expect(afterTransferBalance - beforeTransferBalance, equals(amount));
        expect(RegExp(r'^o\w+$').hasMatch(operationsList.result.id), true);
      });
    });

    group('when the key is not revealed', () {
      Keystore source;

      setUp(() async {
        source = Keystore.random();
        final operationsList =
            await tezart.transfer(source: originatorKeystore, destination: source.address, amount: 100000);
        await operationsList.monitor();
      });

      test('it transfers the amount from source to destination', () async {
        var beforeTransferBalance = await tezart.getBalance(address: destination);
        final operationsList = await subject(source, destination, amount);
        await operationsList.monitor();
        final afterTransferBalance = await tezart.getBalance(address: destination);
        expect(afterTransferBalance - beforeTransferBalance, equals(amount));
        expect(RegExp(r'^o\w+$').hasMatch(operationsList.result.id), true);
      });

      test('it reveals the key', () async {
        final operationsList = await subject(source, destination, amount);
        await operationsList.monitor();
        expect(await tezart.isKeyRevealed(source.address), true);
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
    final subject = (Keystore keystore) => tezart.revealKey(keystore);
    final transferToDest = (Keystore destinationKeystore) async {
      final operationsList = await tezart.transfer(
        source: originatorKeystore,
        destination: destinationKeystore.address,
        amount: 10000,
      );
      await operationsList.monitor();
    };

    group('when the key is not revealed', () {
      final keystore = Keystore.random();

      setUp(() async {
        await transferToDest(keystore);
      });

      test('it reveals the key', () async {
        final operationsList = await subject(keystore);
        await operationsList.monitor();
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

  group('#monitorOperation', () {
    final subject = (String operationId) => tezart.monitorOperation(operationId);

    group('when the operationId exists', () {
      test('it monitors the operation', () async {
        final getBalance = () => tezart.getBalance(address: originatorKeystore.address);
        final destination = Keystore.random();
        final amount = 1;
        final balanceBeforeTransfer = await getBalance();
        final operationsList = await tezart.transfer(
          source: originatorKeystore,
          destination: destination.address,
          amount: amount,
        );
        await subject(operationsList.result.id);
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

// TODO: uncomment tests once Operation refactor is done
//   group('#originateContract', () {
//     final balanceAmount = 1;
//     final storageLimit = 2570;

//     group('when all inputs are valid', () {
//       test('it deploys the contract', () async {
//         final subject = () => tezart.originateContract(
//               source: originatorKeystore,
//               balance: balanceAmount,
//               code: testContractScript['code'],
//               storage: testContractScript['storage'],
//               storageLimit: storageLimit,
//             );

//         await subject();
//       });
//     });

//     group('when script values are invalid', () {
//       test('it fails to deploy the contract', () async {
//         final subject = () => tezart.originateContract(
//               source: originatorKeystore,
//               balance: balanceAmount,
//               code: [{}],
//               storage: {},
//               storageLimit: storageLimit,
//             );

//         await subject();
//       });
//     });
//   });
}
