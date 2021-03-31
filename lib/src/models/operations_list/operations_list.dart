import 'package:logging/logging.dart';
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

  OperationsList(this.source);

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
    final simulationResults = await _rpcInterface.runOperations(operations);

    for (var i = 0; i < simulationResults.length; i++) {
      operations[i].operationResult.simulationResult = simulationResults[i];
    }
  }

  Future<void> forge() async {
    result.forgedOperation = await _rpcInterface.forgeOperations(operations);
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

    result.id = await _rpcInterface.injectOperation(result.signedOperationHex);
  }

  Future<void> execute() async {
    await run();
    await forge();
    sign();
    await inject();
  }

  Future<void> monitor() async {
    log.info('request to monitorOperation ${result.id}');
    final blockHash = await _rpcInterface.monitorOperation(operationId: result.id);
    result.blockHash = blockHash;
  }

  RpcInterface get _rpcInterface {
    // TODO: throw an error if rpc interfaces of operations are not equal
    return operations.first.rpcInterface;
  }
}
