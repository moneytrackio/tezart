import 'package:tezart/src/signature/signature.dart';

/// A class that stores the result of an [OperationsList] object
///
/// - [forgedOperation] is the forge of the operations list
/// - [signature] is the signature of the operations list
/// - [id] is the operation group id. It is computed after the monitoring of the operations list
/// - [blockHash] is the hash of the block that included the operation. It is computer after the monitoring of the operations list
class OperationsListResult {
  String? forgedOperation;
  Signature? signature;
  String? id;
  String? blockHash;
}
