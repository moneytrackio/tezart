import 'package:logging/logging.dart';
import 'package:retry/retry.dart';
import 'package:tezart/src/core/client/tezart_client.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operation/impl/operation_fees_setter_visitor.dart';
import 'package:tezart/src/models/operation/impl/operation_hard_limits_setter_visitor.dart';
import 'package:tezart/src/models/operation/impl/operation_limits_setter_visitor.dart';
import 'package:tezart/src/models/operation/operation.dart';
import 'package:tezart/src/signature/signature.dart';

import 'operations_list_result.dart';

class OperationsList {
  final log = Logger('Operation');
  final List<Operation> operations = [];
  final result = OperationsListResult();
  final Keystore source;
  final RpcInterface rpcInterface;

  OperationsList({required this.source, required this.rpcInterface});

  void prependOperation(Operation op) {
    op.operationsList = this;
    operations.insert(0, op);
  }

  void appendOperation(Operation op) {
    op.operationsList = this;
    operations.add(op);
  }

  Future<void> preapply() async {
    await _catchHttpError<void>(() async {
      if (result.signature == null) throw ArgumentError.notNull('result.signature');

      final simulationResults = await rpcInterface.preapplyOperations(
        operationsList: this,
        signature: result.signature!.edsig,
      );

      for (var i = 0; i < simulationResults.length; i++) {
        operations[i].simulationResult = simulationResults[i];
      }
    });
  }

  Future<void> run() async {
    await _catchHttpError<void>(() async {
      final simulationResults = await rpcInterface.runOperations(this);

      for (var i = 0; i < simulationResults.length; i++) {
        operations[i].simulationResult = simulationResults[i];
      }
    });
  }

  Future<void> forge() async {
    await _catchHttpError<void>(() async {
      result.forgedOperation = await rpcInterface.forgeOperations(this);
    });
  }

  void sign() {
    if (result.forgedOperation == null) throw ArgumentError.notNull('result.forgedOperation');

    result.signature = Signature.fromHex(
      data: result.forgedOperation!,
      keystore: source,
      watermark: Watermarks.generic,
    );
  }

  Future<void> inject() async {
    await _catchHttpError<void>(() async {
      if (result.signature == null) throw ArgumentError.notNull('result.signature');

      result.id = await rpcInterface.injectOperation(result.signature!.hexIncludingPayload);
    });
  }

  Future<void> executeAndMonitor() async {
    await execute();
    await monitor();
  }

  Future<void> execute() async {
    await _retryOnCounterError<void>(() async {
      await estimate();
      await broadcast();
    });
  }

  Future<void> broadcast() async {
    await forge();
    sign();
    await inject();
  }

  Future<void> estimate() async {
    await computeCounters();
    await computeLimits();
    await computeFees();
  }

  Future<void> computeLimits() async {
    await setHighLimits();
    await simulate();
    await setLimits();
  }

  Future<void> simulate() async {
    await forge();
    sign();
    await preapply();
  }

  // TODO: use expirable cache based on time between blocks so that we can
  // call this method before forge, sign, preapply and run
  Future<void> computeCounters() async {
    await _catchHttpError<void>(() async {
      final firstOperation = operations.first;
      firstOperation.counter = await rpcInterface.counter(source.address) + 1;

      for (var i = 1; i < operations.length; i++) {
        operations[i].counter = operations[i - 1].counter! + 1;
      }
    });
  }

  Future<void> setHighLimits() async {
    await Future.wait(operations.map((operation) async {
      await operation.setLimits(OperationHardLimitsSetterVisitor());
    }));
  }

  Future<void> setLimits() async {
    await Future.wait(operations.map((operation) async {
      await operation.setLimits(OperationLimitsSetterVisitor());
    }));

    // resimulate to check that limit computation is valid. Remove this in a stable version ??
    await simulate();
  }

  Future<void> computeFees() async {
    await Future.wait(operations.map((operation) async {
      await operation.setLimits(OperationFeesSetterVisitor());
    }));
  }

  Future<void> monitor() async {
    if (result.id == null) throw ArgumentError.notNull('result.id');

    log.info('request to monitorOperation ${result.id}');
    final blockHash = await rpcInterface.monitorOperation(operationId: result.id!);
    result.blockHash = blockHash;
  }

  Future<T> _catchHttpError<T>(Future<T> Function() func) {
    return catchHttpError<T>(func, onError: (TezartHttpError e) {
      log.severe('Http Error', e);
    });
  }

  Future<T> _retryOnCounterError<T>(func) {
    final r = RetryOptions(maxAttempts: 3);
    return r.retry<T>(
      func,
      retryIf: (e) => e is TezartNodeError && e.type == TezartNodeErrorTypes.counterError,
    );
  }
}
