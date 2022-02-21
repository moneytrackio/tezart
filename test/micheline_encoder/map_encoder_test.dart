// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/micheline_encoder/impl/micheline_encoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic params) => MichelineEncoder(type: type, params: params).encode();

  final type = {
    'prim': 'pair',
    'args': [
      {
        'prim': 'key',
        'annots': ['%pub_key']
      },
      {
        'prim': 'map',
        'args': [
          {'prim': 'string'},
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
                        'prim': 'nat',
                        'annots': ['%price']
                      }
                    ]
                  },
                  {
                    'prim': 'string',
                    'annots': ['%reference']
                  }
                ]
              },
              {
                'prim': 'nat',
                'annots': ['%amount']
              }
            ]
          }
        ],
        'annots': ['%spendings']
      }
    ]
  };

  final params = {
    'pub_key': 'edpkvWLnfNsAKhWEDafxHaTmE8qtK19fSDJYAnLfg7J5Qf5jbkKgTW',
    'spendings': {
      'Spending--001': {'date': DateTime.utc(2020, 1, 1), 'price': 6000, 'reference': 'EG4WA', 'amount': 1000}
    },
  };

  test('it returns a valid value', () {
    final expectedResult = {
      'prim': 'Pair',
      'args': [
        {'string': 'edpkvWLnfNsAKhWEDafxHaTmE8qtK19fSDJYAnLfg7J5Qf5jbkKgTW'},
        [
          {
            'prim': 'Elt',
            'args': [
              {'string': 'Spending--001'},
              {
                'prim': 'Pair',
                'args': [
                  {
                    'prim': 'Pair',
                    'args': [
                      {
                        'prim': 'Pair',
                        'args': [
                          {'int': '1577836800'},
                          {'int': '6000'}
                        ]
                      },
                      {'string': 'EG4WA'}
                    ]
                  },
                  {'int': '1000'}
                ]
              }
            ]
          }
        ]
      ]
    };

    expect(subject(type, params), expectedResult);
  });
}
