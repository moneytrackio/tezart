// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';

import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';

import '../../env/env.dart';

void main() {
  final rpcInterface = RpcInterface(Env.tezosNodeUrl);
  final originator = Keystore.fromSecretKey(Env.originatorSk);

  group('#pendingOperations()', () {
    final subject = () => rpcInterface.pendingOperations();

    test('it returns pending operations', () async {
      final result = await subject();

      expect(
          result.keys, equals(['applied', 'refused', 'outdated', 'branch_refused', 'branch_delayed', 'unprocessed']));
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

  group('#balance()', () {
    final address = originator.address;
    final subject = () => rpcInterface.balance(address);

    test('it returns a positive number', () async {
      final result = await subject();

      expect(result, greaterThan(0));
    });
  });

  group('#managerKey()', () {
    final subject = (String address) => rpcInterface.managerKey(address);
    group('when the address is revealed', () {
      final address = originator.address;

      test('it returns the public key', () async {
        final result = await subject(address);

        expect(result, equals(originator.publicKey));
      });
    });

    group('when the address is unrevealed', () {
      final address = Keystore.random().address;

      test('it returns null', () async {
        final result = await subject(address);

        expect(result, isNull);
      });
    });
  });

  group('#pack()', () {
    final subject =
        ({required dynamic data, required Map<String, dynamic> type}) => rpcInterface.pack(data: data, type: type);

    test('it packs data correctly', () async {
      final data = {'int': '42'};
      final type = {'prim': 'int'};

      expect(await subject(data: data, type: type), '05002a');
    });
  });
}
