import 'package:test/test.dart';
import 'package:tezart/tezart.dart';

import '../../env/env.dart';

void main() {
  final tezart = TezartClient(host: Env.tezosNodeHost, port: Env.tezosNodePort, scheme: Env.tezosNodeScheme);
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);

  group('#transfer', () {
    final source = originatorKeystore;
    final destination = Keystore.random();
    final amount = 1;
    final subject = () => tezart.transfer(source: source, destination: destination.address, amount: amount);

    test('it transfers the amount from source to destination', () async {
      var beforeTransferBalance = await tezart.getBalance(address: destination.address);
      final operationId = await subject();
      await tezart.monitorOperation(operationId: operationId);
      final afterTransferBalance = await tezart.getBalance(address: destination.address);

      expect(afterTransferBalance - beforeTransferBalance, equals(amount));
      expect(RegExp(r'^o\w+$').hasMatch(operationId), true);
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
      final operationId = await tezart.transfer(
        source: originatorKeystore,
        destination: destinationKeystore.address,
        amount: 10000,
      );
      await tezart.monitorOperation(operationId: operationId);
    };

    group('when the key is not revealed', () {
      final keystore = Keystore.random();

      setUp(() => transferToDest(keystore));

      test('it reveals the key', () async {
        final operationId = await subject(keystore);

        await tezart.monitorOperation(operationId: operationId);
        final isKeyRevealed = await tezart.isKeyRevealed(keystore.address);

        expect(isKeyRevealed, isTrue);
      });
    });

    group('when the key is already revealed', () {
      final keystore = originatorKeystore;

      setUp(() => transferToDest(keystore));

      test('throws an error', () async {
        expect(
            subject(keystore),
            throwsA(predicate(
                (e) => e is TezartNodeError && e.message == 'You\'re trying to reveal an already revealed key.')));
      });
    });
  });

  group('#monitorOperation', () {
    final subject = (String operationId) => tezart.monitorOperation(
          operationId: operationId,
          timeBetweenBlocks: Duration(seconds: 2),
        );

    group('when the operationId exists', () {
      test('it monitors the operation', () async {
        final getBalance = () => tezart.getBalance(address: originatorKeystore.address);
        final destination = Keystore.random();
        final amount = 1;
        final balanceBeforeTransfer = await getBalance();
        final operationId = await tezart.transfer(
          source: originatorKeystore,
          destination: destination.address,
          amount: amount,
        );
        final balanceAfterTransfer = await getBalance();
        await subject(operationId);
        final balanceAfterMonitoring = await getBalance();

        expect(balanceBeforeTransfer, equals(balanceAfterTransfer));
        expect(balanceAfterMonitoring, lessThan(balanceAfterTransfer));
      });
    });

    group('when the operationId doesnt exist', () {
      test('it throws an error', () async {
        final operationId = 'toto';
        expect(
            () => subject(operationId),
            throwsA(predicate(
                (e) => e is TezartNodeError && e.message == 'Monitoring the operation $operationId timedout')));
      });
    });
  });
}
