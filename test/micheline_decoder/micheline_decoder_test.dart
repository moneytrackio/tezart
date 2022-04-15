// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/micheline_decoder/micheline_decoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic data) => MichelineDecoder(type: type, data: data).decode();

  group('when the data is annotated', () {
    final data = {
      'prim': 'Pair',
      'args': [
        {'bytes': '00886860e486f58c10f8f01d2dac7853f0cc5266deab1e275b287ecae9e4dec586'},
        [
          {
            'prim': 'Pair',
            'args': [
              {
                'prim': 'Pair',
                'args': [
                  {
                    'prim': 'Pair',
                    'args': [
                      {
                        'prim': 'Pair',
                        'args': [
                          {'int': '9876543'},
                          {'int': '60'}
                        ]
                      },
                      {'string': 'txrsh'}
                    ]
                  },
                  {'int': '10'}
                ]
              },
              {'string': '001'}
            ]
          }
        ]
      ]
    };

    final type = {
      'prim': 'pair',
      'args': [
        {
          'prim': 'key',
          'annots': ['%pub_key']
        },
        {
          'prim': 'list',
          'args': [
            {
              'prim': 'pair',
              'args': [
                {
                  'prim': 'pair',
                  'args': [
                    {
                      'prim': 'pair',
                      'args': [
                        {
                          'prim': 'pair',
                          'args': [
                            {
                              'prim': 'timestamp',
                              'annots': ['%date']
                            },
                            {
                              'prim': 'int',
                              'annots': ['%price']
                            }
                          ]
                        },
                        {
                          'prim': 'string',
                          'annots': ['%ref']
                        }
                      ]
                    },
                    {
                      'prim': 'int',
                      'annots': ['%amount']
                    }
                  ]
                },
                {
                  'prim': 'string',
                  'annots': ['%reference']
                }
              ]
            }
          ],
          'annots': ['%spendings']
        }
      ]
    };

    test('it decodes data correctly', () {
      final expectedResult = {
        'pub_key': 'edpkugJHjEZLNyTuX3wW2dT4P7PY5crLqq3zeDFvXohAs3tnRAaZKR',
        'spendings': [
          {
            'date': isA<DateTime>(),
            'price': 60,
            'ref': 'txrsh',
            'amount': 10,
            'reference': '001',
          }
        ]
      };
      final result = subject(type, data);

      expect(result, expectedResult);
      expect(result['spendings'].first['date'].toUtc(), DateTime.fromMillisecondsSinceEpoch(9876543 * 1000).toUtc());
    });
  });

  group('when the data is anonymous', () {
    final data = {'string': '001'};
    final type = {'prim': 'string'};

    test('it decodes the data correctly', () {
      expect(subject(type, data), '001');
    });
  });
}
