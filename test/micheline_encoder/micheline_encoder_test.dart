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
  });
}
