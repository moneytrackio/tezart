import 'package:meta/meta.dart';

class OperationResult {
  final String id;
  final List<dynamic> simulationResult;
  final String blockHash;

  OperationResult({@required this.id, @required this.simulationResult, @required this.blockHash});
}
