import 'package:test/test.dart';
import 'package:tezart/keystore.dart';
import 'package:tezart/exceptions.dart';
import 'package:tezart/src/tezart/tezart.dart';

import '../env/env.dart';

void main() {
  final tezart = Tezart(host: Env.tezosNodeHost, port: Env.tezosNodePort, scheme: Env.tezosNodeScheme);
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);

  group('#transfer', () {
    final source = originatorKeystore;
    final destination = Keystore.random();
    final amount = 1;
    final subject = () => tezart.transfer(source: source, destination: destination.address, amount: amount);

    test('it transfers the amount from source to destination', () async {
      var beforeTransferBalance = await tezart.getBalance(address: destination.address);
      final result = await subject();
      // TODO: replace this line with operation monitoring
      await Future.delayed(const Duration(seconds: 5));
      final afterTransferBalance = await tezart.getBalance(address: destination.address);

      expect(afterTransferBalance - beforeTransferBalance, equals(amount));
      expect(RegExp(r'^o\w+$').hasMatch(result), true);
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
      await tezart.transfer(source: originatorKeystore, destination: destinationKeystore.address, amount: 10000);
      // TODO: replace this line with operation monitoring
      await Future.delayed(const Duration(seconds: 5));
    };

    group('when the key is not revealed', () {
      final keystore = Keystore.random();

      setUp(() => transferToDest(keystore));

      test('it reveals the key', () async {
        await subject(keystore);

        // TODO: replace this line with operation monitoring
        await Future.delayed(const Duration(seconds: 5));
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
}
