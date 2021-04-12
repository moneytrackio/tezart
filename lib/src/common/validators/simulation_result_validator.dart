import 'package:tezart/tezart.dart';

import 'base_validator.dart';

class SimulationResultValidator implements BaseValidator {
  final Map<String, dynamic> simulationResult;

  SimulationResultValidator(this.simulationResult);

  @override
  bool get isValid {
    return _status == 'applied';
  }

  String get _status {
    // TODO: use ?[] when null safety migration is done
    return _operationResult['status'];
  }

  String get _kind {
    // TODO: use ?[] when null safety migration is done
    return simulationResult['kind'];
  }

  Map<String, dynamic> get _operationResult {
    // TODO: use ?[] when null safety migration is done
    return simulationResult['metadata']['operation_result'];
  }

  String get _reason {
    // ignore the protocol part of the error
    // TODO: use ?[] when null safety migration is done
    return _operationResult['errors'].map((el) => el['id'].split('.').last).join(', ');
  }

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
