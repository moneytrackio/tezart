import 'package:test/test.dart';
import 'package:tezart/keystore.dart';
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
}
