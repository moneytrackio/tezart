import 'package:test/test.dart';
import 'package:tezart/env/env.dart';
import 'package:tezart/keystore.dart';
import 'package:tezart/src/tezart/tezart.dart';

void main() {
  final tezart = Tezart(host: Env.tezosNodeHost, port: Env.tezosNodePort, scheme: Env.tezosNodeScheme);
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);

  group('#transfer', () {
    final source = originatorKeystore;
    final destination = Keystore.random();
    final subject = () => tezart.transfer(source: source, destination: destination.address, amount: 1);

    test('it transfers the amount from source to destination', () async {
      final result = await subject();

      expect(RegExp(r'^oo\w+$').hasMatch(result), true);
    });
  });
}
