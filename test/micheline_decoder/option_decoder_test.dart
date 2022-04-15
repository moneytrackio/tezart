// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/micheline_decoder/micheline_decoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic data) => MichelineDecoder(type: type, data: data).decode();

  final type = {
    'prim': 'pair',
    'args': [
      {
        'prim': 'option',
        'args': [
          {'prim': 'signature'}
        ],
        'annots': ['%sig']
      },
      {
        'prim': 'option',
        'args': [
          {'prim': 'timestamp'}
        ],
        'annots': ['%time']
      }
    ]
  };

  group('with None value', () {
    final data = {
      'prim': 'Pair',
      'args': [
        {'prim': 'None'},
        {'prim': 'None'}
      ]
    };

    test('it decodes data correctly', () {
      expect(subject(type, data), {
        'sig': null,
        'time': null,
      });
    });
  });

  group('with some value', () {
    final data = {
      'prim': 'Pair',
      'args': [
        {
          'prim': 'Some',
          'args': [
            {
              'string':
                  'edsigtp4wchrxPLWscwNQKyUssJixap4njeS3keCTwphwhx4MkQaFn8GfXkCJtk8vi5uV2ahrdS5YWc3qeC74awqWTGJfngKGrs'
            }
          ]
        },
        {
          'prim': 'Some',
          'args': [
            {'int': 1620143003}
          ]
        }
      ]
    };

    test('it decodes data correctly', () {
      final expectedResult = {
        'sig': 'edsigtp4wchrxPLWscwNQKyUssJixap4njeS3keCTwphwhx4MkQaFn8GfXkCJtk8vi5uV2ahrdS5YWc3qeC74awqWTGJfngKGrs',
        'time': isA<DateTime>(),
      };
      final result = subject(type, data);

      expect(result, expectedResult);
      expect(result['time'].toUtc(), DateTime.fromMillisecondsSinceEpoch(1620143003 * 1000).toUtc());
    });
  });
}
