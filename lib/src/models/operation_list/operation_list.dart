import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/models/operation/operation.dart';

class OperationList {
  final List<Operation> opsList = [];

  void prependOperation(Operation op) {
    opsList.insert(0, op);
    if (opsList.length == 1) return;

    for (var i = 1; i < opsList.length - 1; i++) {
      opsList[i].counter = opsList[i + 1].counter;
    }
  }

  void addOperation(Operation op) {
    if (opsList.isNotEmpty) op.counter = opsList.last.counter + 1;
    opsList.add(op);
  }
}
