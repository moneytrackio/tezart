import 'package:test/test.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface_paths.dart';

void testPath(String method, String actual, String expected) {
  test('#$method returns valid value', () {
    expect(expected, equals(actual));
  });
}

void main() {
  const chain = 'main';
  const level = 'head';
  const source = 'edsk4NH16aVF7JHNJ3xHpcsyKSPHdG5U5ZqxksK6APmRVwpAfJzDgV';
  const address = 'tz1MjmdTVSr4T4deDSsb4MXv3tLtKccd9Z1q';

  testPath(
    'pendingOperations',
    pendingOperations(chain),
    'chains/$chain/mempool/pending_operations',
  );
  testPath(
    'branch',
    branch(chain: chain, level: level),
    'chains/$chain/blocks/$level/hash',
  );
  testPath(
    'chainId',
    chainId(chain),
    'chains/$chain/chain_id',
  );

  testPath('counter', counter(chain: chain, level: level, source: source),
      'chains/$chain/blocks/$level/context/contracts/$source/counter');

  testPath(
    'injectOperation',
    injectOperation(chain),
    'injection/operation?chain=$chain',
  );

  testPath('managerKey', managerKey(chain: chain, level: level, address: address),
      'chains/$chain/blocks/$level/context/contracts/$address/manager_key');

  testPath(
    'operationHashes',
    operationHashes(
      chain: chain,
      level: level,
    ),
    'chains/$chain/blocks/$level/operation_hashes/',
  );

  testPath(
    'constants',
    constants(chain: chain, level: level),
    'chains/$chain/blocks/$level/context/constants',
  );

  testPath(
    'block',
    block(chain: chain, level: level),
    'chains/$chain/blocks/$level',
  );
  testPath(
    'protocol',
    protocol(chain: chain, level: level),
    'chains/$chain/blocks/$level/metadata',
  );

  testPath(
    'forgeOperations',
    forgeOperations(chain: chain, level: level),
    'chains/$chain/blocks/$level/helpers/forge/operations',
  );

  testPath(
    'runOperations',
    runOperations(chain: chain, level: level),
    'chains/$chain/blocks/$level/helpers/scripts/run_operation',
  );

  testPath(
    'balance',
    balance(chain: chain, level: level, address: address),
    'chains/$chain/blocks/$level/context/contracts/$address',
  );

  testPath(
    'monitor',
    monitor(chain),
    'monitor/heads/$chain',
  );
}
