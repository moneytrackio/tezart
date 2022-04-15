// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/micheline_encoder/micheline_encoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic params) => MichelineEncoder(type: type, params: params).encode();

  final params = [
    {'reference': 'txrsh', 'reference_2': '001'},
    {'reference': '2', 'reference_2': '002'},
  ];

  final type = {
    'prim': 'list',
    'args': [
      {
        'prim': 'pair',
        'args': [
          {
            'prim': 'string',
            'annots': ['%reference']
          },
          {
            'prim': 'string',
            'annots': ['%reference_2']
          }
        ]
      }
    ]
  };

  test('it returns a valid value', () {
    final expectedResult = [
      {
        'prim': 'Pair',
        'args': [
          {'string': 'txrsh'},
          {'string': '001'}
        ]
      },
      {
        'prim': 'Pair',
        'args': [
          {'string': '2'},
          {'string': '002'}
        ]
      }
    ];

    expect(subject(type, params), expectedResult);
  });
}
