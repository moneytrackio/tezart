@Timeout(Duration(seconds: 60))
import 'package:test/test.dart';
import 'package:tezart/src/models/operation/impl/operation_high_limits.dart';
import 'package:tezart/tezart.dart';

import '../env/env.dart';

void main() {
  final tezart = TezartClient(Env.tezosNodeUrl);
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);
  final rpcInterface = tezart.rpcInterface;
  Operation operation;

  setUp(() {
    operation = Operation(kind: Kinds.generic);
  });

  group('#gas', () {
    final subject = () async => OperationHighLimits(operation).gas;
    setUp(() {
      OperationsList(
        source: originatorKeystore,
        rpcInterface: rpcInterface,
      ).appendOperation(operation);
    });

    test('it returns the hard_gas_limit_per_operation node constant', () async {
      expect(await subject(), 1040000);
    });
  });

  group('#storage', () {
    final subject = () async => OperationHighLimits(operation).storage;

    group('when the source balance storage limitation is greater than the hard storage limitation per operation', () {
      setUp(() {
        OperationsList(
          source: originatorKeystore,
          rpcInterface: rpcInterface,
        ).appendOperation(operation);
      });

      test('it returns the hard storage limitation per operation', () async {
        expect(await subject(), 60000);
      });
    });

    group('when the source balance storage limitation is lesser than the hard storage limitation per operation', () {
      setUp(() async {
        final destination = Keystore.random();
        final operationsList = await tezart.transferOperation(
          source: originatorKeystore,
          destination: destination.address,
          amount: 10000,
        );
        await operationsList.executeAndMonitor();
        final revealOperation = await tezart.revealKeyOperation(destination);
        await revealOperation.executeAndMonitor();

        OperationsList(
          source: destination,
          rpcInterface: rpcInterface,
        ).appendOperation(operation);
      });

      test('it returns the balance storage limitation', () async {
        expect(await subject(), lessThan(9699));
        expect(await subject(), greaterThan(9690));
      });
    });
  });
}
