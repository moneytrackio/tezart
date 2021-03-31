import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operation/operation.dart';
import 'package:tezart/src/signature/signature.dart';

import 'operations_list_result.dart';

class OperationsList {
  final log = Logger('Operation');
  final List<Operation> operations = [];
  final result = OperationsListResult();
  final Keystore source;
  final RpcInterface rpcInterface;

  OperationsList({@required this.source, @required this.rpcInterface});

  void prependOperation(Operation op) {
    op.operationsList = this;
    operations.insert(0, op);
    if (operations.length == 1) return;

    for (var i = 1; i < operations.length - 1; i++) {
      operations[i].counter = operations[i + 1].counter;
    }
  }

  void addOperation(Operation op) {
    op.operationsList = this;
    if (operations.isNotEmpty) op.counter = operations.last.counter + 1;
    operations.add(op);
  }

  Future<void> run() async {
    final simulationResults = await rpcInterface.runOperations(operations);

    for (var i = 0; i < simulationResults.length; i++) {
      operations[i].simulationResult = simulationResults[i];
    }
  }

  Future<void> forge() async {
    result.forgedOperation = await rpcInterface.forgeOperations(operations);
  }

  void sign() {
    if (result.forgedOperation == null) throw ArgumentError.notNull('result.forgedOperation');

    result.signedOperationHex = Signature.fromHex(
      data: result.forgedOperation,
      keystore: source,
      watermark: Watermarks.generic,
    ).hexIncludingPayload;
  }

  Future<void> inject() async {
    if (result.signedOperationHex == null) throw ArgumentError.notNull('result.signedOperationHex');

    result.id = await rpcInterface.injectOperation(result.signedOperationHex);
  }

  Future<void> execute() async {
    await run();
    await forge();
    sign();
    await inject();
  }

  Future<void> monitor() async {
    log.info('request to monitorOperation ${result.id}');
    final blockHash = await rpcInterface.monitorOperation(operationId: result.id);
    result.blockHash = blockHash;
  }
}
