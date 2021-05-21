import 'package:tezart/tezart.dart';

import 'base_validator.dart';

/// A validator that checks whether [simulationResult] is applied
///
/// [simulationResult] is supposed to be the result of [rpcInterface.runOperations] of [rpcInterface.preapplyOperations]
class SimulationResultValidator implements BaseValidator {
  final Map<String, dynamic> simulationResult;

  SimulationResultValidator(this.simulationResult);

  /// Returns true if the status of this is 'applied'
  @override
  bool get isValid {
    return _status == 'applied';
  }

  String get _status {
    return _operationResult['status'];
  }

  String get _kind {
    return simulationResult['kind'];
  }

  Map<String, dynamic> get _operationResult {
    final operationResult = simulationResult['metadata']?['operation_result'];
    if (operationResult == null) throw ArgumentError.notNull("simulationResult['metadata']?['operation_result']");

    return operationResult;
  }

  String get _reason {
    final errors = _operationResult['errors'];

    if (errors == null) throw ArgumentError.notNull("_operationResult['errors']");

    // ignore the protocol part of the error ("proto.007-PsDELPH1" part)
    return _operationResult['errors'].map((el) => (el['id'] as String?)?.split('.').sublist(2).join('.')).join(', ');
  }

  /// Throws [TezartNodeError] if [_status] is not 'applied'
  @override
  void validate() {
    if (!isValid) {
      final metadata = {
        'operationKind': _kind,
        'reason': _reason,
      };

      throw TezartNodeError(
        type: TezartNodeErrorTypes.simulationFailed,
        metadata: metadata,
      );
    }
  }
}
