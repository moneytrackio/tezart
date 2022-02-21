// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/common/validators/simulation_result_validator.dart';
import 'package:tezart/tezart.dart';

void main() {
  final subject = (Map<String, dynamic> simulationResult) => SimulationResultValidator(simulationResult).validate();

  group('when the simulation result status is applied', () {
    final simulationResult = {
      'kind': 'origination',
      'metadata': {
        'operation_result': {'status': 'applied'}
      }
    };

    test('it doesnt throw an error', () {
      expect(() => subject(simulationResult), returnsNormally);
    });
  });

  group('when the simulation result status is failed', () {
    final simulationResult = {
      'kind': 'origination',
      'metadata': {
        'operation_result': {
          'status': 'failed',
          'errors': [
            {
              'id': 'proto.123.error1',
            },
            {
              'id': 'proto.123.error2',
            },
          ],
        },
      },
    };

    test('it throws a TezartNodeError', () {
      expect(
          () => subject(simulationResult),
          throwsA(
            predicate((e) =>
                e is TezartNodeError &&
                e.type == TezartNodeErrorTypes.simulationFailed &&
                e.message == 'The simulation of the operation: "origination" failed with error(s) : error1, error2'),
          ));
    });
  });
}
