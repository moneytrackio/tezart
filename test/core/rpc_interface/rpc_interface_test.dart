import 'package:test/test.dart';

import 'package:tezart/env/env.dart';
import 'package:tezart/src/core/rpc_interface/rpc_interface.dart';

void main() {
  final rpcInterface = RpcInterface(host: Env.tezosNodeHost, port: Env.tezosNodePort, scheme: Env.tezosNodeScheme);

  group('#pendingOperations()', () {
    final subject = () => rpcInterface.pendingOperations();

    test('it returns pending operations', () async {
      final result = await subject();

      expect(result.keys, equals(['applied', 'refused', 'branch_refused', 'branch_delayed', 'unprocessed']));
    });
  });

  group('#branch()', () {
    final subject = () => rpcInterface.branch();

    test('it returns the branch hash', () async {
      final result = await subject();

      expect(RegExp(r'^B\w+$').hasMatch(result), true);
    });
  });

  group('#chainId()', () {
    final subject = () => rpcInterface.chainId();

    test('it returns the chain id', () async {
      final result = await subject();

      expect(RegExp(r'^Net\w+$').hasMatch(result), true);
    });
  });

  group('#protocol()', () {
    final subject = () => rpcInterface.protocol();

    test('it returns the current protocol', () async {
      final result = await subject();

      expect(RegExp(r'^P\w+$').hasMatch(result), true);
    });
  });

  group('#counter()', () {
    final address = 'tz1edmE1ZtizUW2qRj5XA2BLuiR8pRDnoBRg';
    final subject = () => rpcInterface.counter(address);

    test('it returns an int', () async {
      final result = await subject();

      expect(result, isA<int>());
    });
  });
}