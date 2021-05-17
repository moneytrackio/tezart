final List<Map<String, dynamic>> testContractScript = [
  {
    'prim': 'storage',
    'args': [
      {'prim': 'int'}
    ]
  },
  {
    'prim': 'parameter',
    'args': [
      {'prim': 'unit'}
    ]
  },
  {
    'prim': 'code',
    'args': [
      [
        {'prim': 'CDR'},
        {
          'prim': 'NIL',
          'args': [
            {'prim': 'operation'}
          ]
        },
        {'prim': 'PAIR'}
      ]
    ]
  }
];

final List<Map<String, dynamic>> storeValueContract = [
  {
    'prim': 'storage',
    'args': [
      {'prim': 'nat'}
    ]
  },
  {
    'prim': 'parameter',
    'args': [
      {
        'prim': 'or',
        'args': [
          {
            'prim': 'nat',
            'annots': ['%divide']
          },
          {
            'prim': 'or',
            'args': [
              {
                'prim': 'unit',
                'annots': ['%double']
              },
              {
                'prim': 'nat',
                'annots': ['%replace']
              }
            ]
          }
        ]
      }
    ]
  },
  {
    'prim': 'code',
    'args': [
      [
        {'prim': 'UNPAIR'},
        {
          'prim': 'IF_LEFT',
          'args': [
            [
              {'prim': 'DUP'},
              {
                'prim': 'PUSH',
                'args': [
                  {'prim': 'nat'},
                  {'int': '5'}
                ]
              },
              {'prim': 'COMPARE'},
              {'prim': 'LT'},
              {
                'prim': 'IF',
                'args': [
                  [],
                  [
                    {
                      'prim': 'PUSH',
                      'args': [
                        {'prim': 'string'},
                        {'string': 'WrongCondition: params.divisor > 5'}
                      ]
                    },
                    {'prim': 'FAILWITH'}
                  ]
                ]
              },
              {'prim': 'SWAP'},
              {'prim': 'EDIV'},
              {
                'prim': 'IF_NONE',
                'args': [
                  [
                    {
                      'prim': 'PUSH',
                      'args': [
                        {'prim': 'int'},
                        {'int': '20'}
                      ]
                    },
                    {'prim': 'FAILWITH'}
                  ],
                  [
                    {'prim': 'CAR'}
                  ]
                ]
              }
            ],
            [
              {
                'prim': 'IF_LEFT',
                'args': [
                  [
                    {'prim': 'DROP'},
                    {
                      'prim': 'PUSH',
                      'args': [
                        {'prim': 'nat'},
                        {'int': '2'}
                      ]
                    },
                    {'prim': 'MUL'}
                  ],
                  [
                    {'prim': 'SWAP'},
                    {'prim': 'DROP'}
                  ]
                ]
              }
            ]
          ]
        },
        {
          'prim': 'NIL',
          'args': [
            {'prim': 'operation'}
          ]
        },
        {'prim': 'PAIR'}
      ]
    ]
  }
];

final bigMapContract = [
  {
    'prim': 'storage',
    'args': [
      {
        'prim': 'big_map',
        'args': [
          {'prim': 'string'},
          {'prim': 'string'}
        ]
      }
    ]
  },
  {
    'prim': 'parameter',
    'args': [
      {
        'prim': 'pair',
        'args': [
          {
            'prim': 'string',
            'annots': ['%my_key']
          },
          {
            'prim': 'string',
            'annots': ['%my_val']
          }
        ],
        'annots': ['%add_value']
      }
    ]
  },
  {
    'prim': 'code',
    'args': [
      [
        {'prim': 'UNPAIR'},
        {'prim': 'DUP'},
        {
          'prim': 'DUG',
          'args': [
            {'int': '2'}
          ]
        },
        {'prim': 'CDR'},
        {'prim': 'SOME'},
        {
          'prim': 'DIG',
          'args': [
            {'int': '2'}
          ]
        },
        {'prim': 'CAR'},
        {'prim': 'UPDATE'},
        {
          'prim': 'NIL',
          'args': [
            {'prim': 'operation'}
          ]
        },
        {'prim': 'PAIR'}
      ]
    ]
  }
];

final noStorageContract = [
  {
    'prim': 'storage',
    'args': [
      {'prim': 'unit'}
    ]
  },
  {
    'prim': 'parameter',
    'args': [
      {
        'prim': 'unit',
        'annots': ['%empty_entrypoint']
      }
    ]
  },
  {
    'prim': 'code',
    'args': [
      [
        {'prim': 'CDR'},
        {
          'prim': 'NIL',
          'args': [
            {'prim': 'operation'}
          ]
        },
        {'prim': 'PAIR'}
      ]
    ]
  }
];

final multipleStructuresContract = [
  {
    'prim': 'storage',
    'args': [
      {
        'prim': 'pair',
        'args': [
          {
            'prim': 'big_map',
            'args': [
              {'prim': 'string'},
              {'prim': 'string'}
            ],
            'annots': ['%my_big_map']
          },
          {
            'prim': 'pair',
            'args': [
              {
                'prim': 'big_map',
                'args': [
                  {'prim': 'string'},
                  {'prim': 'string'}
                ],
                'annots': ['%my_big_map_2']
              },
              {
                'prim': 'map',
                'args': [
                  {'prim': 'string'},
                  {'prim': 'string'}
                ],
                'annots': ['%my_map']
              }
            ]
          }
        ]
      }
    ]
  },
  {
    'prim': 'parameter',
    'args': [
      {
        'prim': 'pair',
        'args': [
          {
            'prim': 'string',
            'annots': ['%my_key']
          },
          {
            'prim': 'string',
            'annots': ['%my_val']
          }
        ],
        'annots': ['%add_value']
      }
    ]
  },
  {
    'prim': 'code',
    'args': [
      [
        {'prim': 'UNPAIR'},
        {'prim': 'SWAP'},
        {'prim': 'DUP'},
        {'prim': 'CAR'},
        {
          'prim': 'DUP',
          'args': [
            {'int': '3'}
          ]
        },
        {'prim': 'CDR'},
        {'prim': 'SOME'},
        {
          'prim': 'DUP',
          'args': [
            {'int': '4'}
          ]
        },
        {'prim': 'CAR'},
        {'prim': 'UPDATE'},
        {
          'prim': 'UPDATE',
          'args': [
            {'int': '1'}
          ]
        },
        {'prim': 'DUP'},
        {
          'prim': 'GET',
          'args': [
            {'int': '3'}
          ]
        },
        {
          'prim': 'DUP',
          'args': [
            {'int': '3'}
          ]
        },
        {'prim': 'CDR'},
        {'prim': 'SOME'},
        {
          'prim': 'DUP',
          'args': [
            {'int': '4'}
          ]
        },
        {'prim': 'CAR'},
        {'prim': 'UPDATE'},
        {
          'prim': 'UPDATE',
          'args': [
            {'int': '3'}
          ]
        },
        {'prim': 'DUP'},
        {
          'prim': 'GET',
          'args': [
            {'int': '4'}
          ]
        },
        {
          'prim': 'DUP',
          'args': [
            {'int': '3'}
          ]
        },
        {'prim': 'CDR'},
        {'prim': 'SOME'},
        {
          'prim': 'DIG',
          'args': [
            {'int': '3'}
          ]
        },
        {'prim': 'CAR'},
        {'prim': 'UPDATE'},
        {
          'prim': 'UPDATE',
          'args': [
            {'int': '4'}
          ]
        },
        {
          'prim': 'NIL',
          'args': [
            {'prim': 'operation'}
          ]
        },
        {'prim': 'PAIR'}
      ]
    ]
  }
];
