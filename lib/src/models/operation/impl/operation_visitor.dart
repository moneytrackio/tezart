import 'operation.dart';

abstract class OperationVisitor {
  Future<void> visit(Operation operation);
}
