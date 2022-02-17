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

final List<Map<String, dynamic>> demoContract = [
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
              {'prim': 'int'}
            ],
            'annots': ['%big_map_first']
          },
          {
            'prim': 'big_map',
            'args': [
              {'prim': 'string'},
              {'prim': 'string'}
            ],
            'annots': ['%big_map_second']
          }
        ]
      }
    ]
  },
  {
    'prim': 'parameter',
    'args': [
      {
        'prim': 'or',
        'args': [
          {
            'prim': 'or',
            'args': [
              {
                'prim': 'pair',
                'args': [
                  {
                    'prim': 'string',
                    'annots': ['%key']
                  },
                  {
                    'prim': 'int',
                    'annots': ['%value']
                  }
                ],
                'annots': ['%add_first']
              },
              {
                'prim': 'pair',
                'args': [
                  {
                    'prim': 'string',
                    'annots': ['%key']
                  },
                  {
                    'prim': 'string',
                    'annots': ['%value']
                  }
                ],
                'annots': ['%add_second']
              }
            ]
          },
          {
            'prim': 'or',
            'args': [
              {
                'prim': 'pair',
                'args': [
                  {
                    'prim': 'pair',
                    'args': [
                      {
                        'prim': 'string',
                        'annots': ['%first']
                      },
                      {
                        'prim': 'string',
                        'annots': ['%key']
                      }
                    ]
                  },
                  {
                    'prim': 'pair',
                    'args': [
                      {
                        'prim': 'string',
                        'annots': ['%second']
                      },
                      {
                        'prim': 'string',
                        'annots': ['%third']
                      }
                    ]
                  }
                ],
                'annots': ['%add_third']
              },
              {
                'prim': 'nat',
                'annots': ['%always_fail']
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
              {
                'prim': 'IF_LEFT',
                'args': [
                  [
                    {'prim': 'SWAP'},
                    {'prim': 'UNPAIR'},
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
                    {'prim': 'PAIR'}
                  ],
                  [
                    {'prim': 'SWAP'},
                    {'prim': 'UNPAIR'},
                    {'prim': 'SWAP'},
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
                    {'prim': 'SWAP'},
                    {'prim': 'PAIR'}
                  ]
                ]
              }
            ],
            [
              {
                'prim': 'IF_LEFT',
                'args': [
                  [
                    {'prim': 'SWAP'},
                    {'prim': 'UNPAIR'},
                    {'prim': 'SWAP'},
                    {
                      'prim': 'DIG',
                      'args': [
                        {'int': '2'}
                      ]
                    },
                    {'prim': 'DUP'},
                    {
                      'prim': 'GET',
                      'args': [
                        {'int': '4'}
                      ]
                    },
                    {'prim': 'SWAP'},
                    {'prim': 'DUP'},
                    {
                      'prim': 'GET',
                      'args': [
                        {'int': '3'}
                      ]
                    },
                    {'prim': 'SWAP'},
                    {'prim': 'DUP'},
                    {
                      'prim': 'DUG',
                      'args': [
                        {'int': '5'}
                      ]
                    },
                    {'prim': 'CAR'},
                    {'prim': 'CAR'},
                    {'prim': 'CONCAT'},
                    {'prim': 'CONCAT'},
                    {'prim': 'SOME'},
                    {
                      'prim': 'DIG',
                      'args': [
                        {'int': '3'}
                      ]
                    },
                    {'prim': 'CAR'},
                    {'prim': 'CDR'},
                    {'prim': 'UPDATE'},
                    {'prim': 'SWAP'},
                    {'prim': 'PAIR'}
                  ],
                  [
                    {
                      'prim': 'PUSH',
                      'args': [
                        {'prim': 'nat'},
                        {'int': '0'}
                      ]
                    },
                    {'prim': 'SWAP'},
                    {'prim': 'COMPARE'},
                    {'prim': 'GE'},
                    {
                      'prim': 'IF',
                      'args': [
                        [
                          {
                            'prim': 'PUSH',
                            'args': [
                              {'prim': 'string'},
                              {'string': "I'm failing"}
                            ]
                          },
                          {'prim': 'FAILWITH'}
                        ],
                        []
                      ]
                    }
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
