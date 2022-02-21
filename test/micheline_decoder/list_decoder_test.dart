// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/micheline_decoder/impl/micheline_decoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic data) => MichelineDecoder(type: type, data: data).decode();

  final data = [
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
            'annots': ['%id']
          }
        ]
      }
    ]
  };

  test('it returns the correct value', () {
    final expectedResult = [
      {'reference': 'txrsh', 'id': '001'},
      {'reference': '2', 'id': '002'}
    ];

    expect(subject(type, data), expectedResult);
  });
}
