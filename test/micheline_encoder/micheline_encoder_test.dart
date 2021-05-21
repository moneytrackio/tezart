import 'package:test/test.dart';
import 'package:tezart/src/micheline_encoder/impl/micheline_encoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic params) => MichelineEncoder(type: type, params: params).encode();

  group('when type and params are valid', () {
    group('when there is multiple parameters', () {
      final type = {
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
        'expires_at': DateTime.utc(2020, 1, 1),
      };

      test('it returns a valid value', () {
        expect(subject(type, params), {
          'prim': 'Pair',
          'args': [
            {
              'prim': 'Pair',
              'args': [
                {
                  'prim': 'Pair',
                  'args': [
                    {'int': '1577836800'},
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
      final type = {
        'prim': 'string',
        'annots': ['%payload']
      };
      final params = {'payload': 'payload'};

      test('it returns a valid value', () {
        expect(subject(type, params), {'string': 'payload'});
      });
    });

    group('when the parameter is anonymous', () {
      final type = {
        'prim': 'string',
      };
      final params = 'payload';

      test('it returns a valid value', () {
        expect(subject(type, params), {'string': 'payload'});
      });
    });

    group('when the params is a List', () {
      final params = ['1234', 'KT1UDJmqKvMYRcGzP2TSFhQqejS2CKaDsNEx', '4567'];
      final type = {
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
        expect(subject(type, params), {
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
