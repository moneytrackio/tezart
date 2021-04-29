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
        'expires_at': DateTime.now(),
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
                    {'int': (params['expires_at'] as DateTime).millisecondsSinceEpoch.toString()},
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
          'valid_until': DateTime.now(),
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
                  {'int': (params['valid_until'] as DateTime).millisecondsSinceEpoch.toString()},
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
