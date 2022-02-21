// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/contracts/contract.dart';
import 'package:tezart/src/micheline_decoder/micheline_decoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic data) => MichelineDecoder(type: type, data: data).decode();

  final data = {
    'prim': 'Pair',
    'args': [
      {
        'prim': 'Pair',
        'args': [
          {'int': '70'},
          {'string': 'tz1ZWiiPXowuhN1UqNGVTrgNyf5tdxp4XUUq'}
        ]
      },
      {'int': '71'}
    ]
  };

  final type = {
    'prim': 'pair',
    'args': [
      {
        'prim': 'pair',
        'args': [
          {
            'prim': 'big_map',
            'args': [
              {'prim': 'string'},
              {
                'prim': 'pair',
                'args': [
                  {
                    'prim': 'address',
                    'annots': ['%contract_address']
                  },
                  {
                    'prim': 'key',
                    'annots': ['%contract_owner']
                  }
                ]
              }
            ],
            'annots': ['%contracts']
          },
          {
            'prim': 'address',
            'annots': ['%owner']
          }
        ]
      },
      {
        'prim': 'big_map',
        'args': [
          {'prim': 'string'},
          {'prim': 'address'}
        ],
        'annots': ['%spendings']
      }
    ]
  };
  test('it decodes data correctly', () {
    final result = subject(type, data);
    expect(result, {
      'contracts': isA<BigMap>(),
      'owner': 'tz1ZWiiPXowuhN1UqNGVTrgNyf5tdxp4XUUq',
      'spendings': isA<BigMap>(),
    });

    expect(result['contracts'], isA<BigMap>());
    final BigMap contractsBigMap = result['contracts'];
    expect(contractsBigMap.id, '70');
    expect(
      contractsBigMap.valueType,
      {
        'prim': 'pair',
        'args': [
          {
            'prim': 'address',
            'annots': ['%contract_address']
          },
          {
            'prim': 'key',
            'annots': ['%contract_owner']
          }
        ]
      },
    );

    expect(contractsBigMap.keyType, {'prim': 'string'});
    expect(contractsBigMap.name, 'contracts');
  });
}
