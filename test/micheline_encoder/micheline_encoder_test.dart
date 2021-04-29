import 'package:test/test.dart';
import 'package:tezart/src/micheline_encoder/impl/micheline_encoder.dart';

void main() {
  final subject =
      (Map<String, dynamic> schema, dynamic params) => MichelineEncoder(schema: schema, params: params).encode();

  group('when schema and params are valid', () {
    group('when there is multiple parameters', () {
      final schema = {
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
                    'annots': ['%expires_at']
                  },
                  {
                    'prim': 'string',
                    'annots': ['%id']
                  }
                ]
              },
              {
                'prim': 'bytes',
                'annots': ['%payload']
              }
            ]
          },
          {
            'prim': 'string',
            'annots': ['%reference']
          }
        ]
      };
      final params = {
        'payload': 'payload',
        'reference': 'reference',
        'id': 'id',
        'expires_at': DateTime(2020, 1, 1),
      };

      test('it returns a valid value', () {
        expect(subject(schema, params), {
          'prim': 'Pair',
          'args': [
            {
              'prim': 'Pair',
              'args': [
                {
                  'prim': 'Pair',
                  'args': [
                    {'int': '1577833200'},
                    {'string': 'id'}
                  ]
                },
                {'bytes': 'payload'}
              ]
            },
            {'string': 'reference'}
          ]
        });
      });
    });

    group('when there is only one parameter', () {
      final schema = {
        'prim': 'string',
        'annots': ['%payload']
      };
      final params = {'payload': 'payload'};

      test('it returns a valid value', () {
        expect(subject(schema, params), {'string': 'payload'});
      });
    });

    group('when the parameter is anonymous', () {
      final schema = {
        'prim': 'string',
      };
      final params = 'payload';

      test('it returns a valid value', () {
        expect(subject(schema, params), {'string': 'payload'});
      });
    });

    group('with list type', () {
      final params = [
        {'reference': 'txrsh', 'reference_2': '001'},
        {'reference': '2', 'reference_2': '002'},
      ];

      final schema = {
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

        expect(subject(schema, params), expectedResult);
      });
    });

    group('with map type', () {
      final schema = {
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
          'Spending--001': {'date': DateTime(2020, 1, 1), 'price': 6000, 'reference': 'EG4WA', 'amount': 1000}
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
                              {'int': '1577833200'},
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

        expect(subject(schema, params), expectedResult);
      });
    });

    group('with option type', () {
      final schema = {
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
          expect(subject(schema, params), {
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
          'valid_until': DateTime(2020, 1, 1),
          'signature':
              'edsigtp4wchrxPLWscwNQKyUssJixap4njeS3keCTwphwhx4MkQaFn8GfXkCJtk8vi5uV2ahrdS5YWc3qeC74awqWTGJfngKGrs',
        };

        test('it returns a valid value', () {
          expect(subject(schema, params), {
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
                  {'int': '1577833200'},
                ]
              }
            ]
          });
        });
      });
    });

    group('when the params is a List', () {
      final params = ['1234', 'KT1UDJmqKvMYRcGzP2TSFhQqejS2CKaDsNEx', '4567'];
      final schema = {
        'prim': 'pair',
        'args': [
          {
            'prim': 'string',
          },
          {
            'prim': 'pair',
            'args': [
              {
                'prim': 'string',
              },
              {
                'prim': 'string',
              }
            ]
          }
        ]
      };

      test('it returns a valid value', () {
        expect(subject(schema, params), {
          'args': [
            {'string': '1234'},
            {
              'args': [
                {'string': 'KT1UDJmqKvMYRcGzP2TSFhQqejS2CKaDsNEx'},
                {'string': '4567'}
              ],
              'prim': 'Pair'
            }
          ],
          'prim': 'Pair',
        });
      });
    });
  });
}
