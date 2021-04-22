import 'operation.dart';

abstract class OperationVisitor {
  void visit(Operation operation);
}
