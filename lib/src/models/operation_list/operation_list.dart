import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/models/operation/operation.dart';

class OperationList {
  List<Operation> opsList = [];

  void addOperation(Operation op) {
    if (opsList.isNotEmpty) op.counter = opsList.last.counter + 1;
    opsList.add(op);
  }
}
