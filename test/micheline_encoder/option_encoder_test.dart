// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/micheline_encoder/micheline_encoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic params) => MichelineEncoder(type: type, params: params).encode();

  final type = {
    'prim': 'pair',
    'args': [
      {
        'prim': 'option',
        'args': [
          {'prim': 'signature'}
        ],
        'annots': ['%signature']
      },
      {
        'prim': 'option',
        'args': [
          {'prim': 'timestamp'},
        ],
        'annots': ['%valid_until']
      }
    ]
  };

  group('with null values', () {
    final params = {
      'valid_until': null,
      'signature': null,
    };

    test('it returns a valid value', () {
      expect(subject(type, params), {
        'prim': 'Pair',
        'args': [
          {'prim': 'None'},
          {'prim': 'None'}
        ]
      });
    });
  });

  group('with some values', () {
    final params = {
      'valid_until': DateTime.utc(2020, 1, 1),
      'signature':
          'edsigtp4wchrxPLWscwNQKyUssJixap4njeS3keCTwphwhx4MkQaFn8GfXkCJtk8vi5uV2ahrdS5YWc3qeC74awqWTGJfngKGrs',
    };

    test('it returns a valid value', () {
      expect(subject(type, params), {
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
              {'int': '1577836800'},
            ]
          }
        ]
      });
    });
  });
}
