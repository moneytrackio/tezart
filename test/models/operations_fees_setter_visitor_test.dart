@Timeout(Duration(seconds: 60))
import 'package:test/test.dart';
import 'package:tezart/src/models/operation/impl/operation_fees_setter_visitor.dart';
import 'package:tezart/tezart.dart';

import '../env/env.dart';

void main() {
  final tezart = TezartClient(Env.tezosNodeUrl);
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);
  late Operation operation;

  group('when the operation customFee is set', () {
    const customFee = 1234;
    final subject = () => OperationFeesSetterVisitor().visit(operation);

    setUp(() {
      operation = Operation(kind: Kinds.generic, customFee: customFee);
    });

    test('it sets operation.fee using customFee', () async {
      await subject();
      expect(operation.fee, customFee);
    });
  });

  group('when the operation customFee is not set', () {
    final subject = () => OperationFeesSetterVisitor().visit(operation);

    setUp(() async {
      final destination = Keystore.random();
      final operationsList = await tezart.transferOperation(
        source: originatorKeystore,
        destination: destination.address,
        amount: 1000,
      );
      operation = operationsList.operations.last;
      await operationsList.computeCounters();
      await operationsList.computeLimits();
    });

    test('it computes the fees using the operation simulation', () async {
      await subject();
      expect(operation.fee, lessThan(64592));
    });
  });
}
