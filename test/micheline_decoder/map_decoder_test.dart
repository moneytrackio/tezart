// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/micheline_decoder/impl/micheline_decoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic data) => MichelineDecoder(type: type, data: data).decode();

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
                    'annots': ['%ref']
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

  group('when the map contains elements', () {
    final data = {
      'prim': 'Pair',
      'args': [
        {'string': 'edpkvWLnfNsAKhWEDafxHaTmE8qtK19fSDJYAnLfg7J5Qf5jbkKgTW'},
        [
          {
            'prim': 'Elt',
            'args': [
              {'string': '001'},
              {
                'prim': 'Pair',
                'args': [
                  {
                    'prim': 'Pair',
                    'args': [
                      {
                        'prim': 'Pair',
                        'args': [
                          {'string': '2020-04-27T13:48:28Z'},
                          {'int': '6000'}
                        ]
                      },
                      {'string': 'HEALTH_PRACTITIONER_EG4WA'}
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

    test('it returns a valid value', () {
      final expectedResult = {
        'pub_key': 'edpkvWLnfNsAKhWEDafxHaTmE8qtK19fSDJYAnLfg7J5Qf5jbkKgTW',
        'spendings': {
          '001': {
            'date': DateTime.parse('2020-04-27T13:48:28Z'),
            'price': 6000,
            'ref': 'HEALTH_PRACTITIONER_EG4WA',
            'amount': 1000
          }
        },
      };

      expect(subject(type, data), expectedResult);
    });
  });

  group('when the map is empty', () {
    final data = {
      'prim': 'Pair',
      'args': [
        {'string': 'edpkvH2XCYHmU2cpJxzQxzaJ9iMfmvkvSixFsEE1KqEmXBQeFq78PT'},
        []
      ]
    };

    test('it returns a valid value', () {
      final expectedResult = {
        'pub_key': 'edpkvH2XCYHmU2cpJxzQxzaJ9iMfmvkvSixFsEE1KqEmXBQeFq78PT',
        'spendings': {},
      };

      expect(subject(type, data), expectedResult);
    });
  });
}
