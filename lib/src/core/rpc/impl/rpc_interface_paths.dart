// ignore_for_file: prefer_function_declarations_over_variables

final pendingOperations = (String chain) => '${_chainPath(chain)}/mempool/pending_operations';
final branch = ({required String chain, required String level}) => '${_levelPath(chain: chain, level: level)}/hash';
final block = ({required String chain, required String level}) => _levelPath(level: level, chain: chain);
final chainId = (String chain) => '${_chainPath(chain)}/chain_id';

final counter = ({required String chain, required String level, required String source}) =>
    '${_levelPath(chain: chain, level: level)}/context/contracts/$source/counter';

final protocol =
    ({required String chain, required String level}) => '${_levelPath(chain: chain, level: level)}/metadata';

final forgeOperations = ({required String chain, required String level}) =>
    '${_levelPath(chain: chain, level: level)}/helpers/forge/operations';

final runOperations = ({required String chain, required String level}) =>
    '${_levelPath(chain: chain, level: level)}/helpers/scripts/run_operation';

final preapplyOperations = ({required String chain, required String level}) =>
    '${_levelPath(chain: chain, level: level)}/helpers/preapply/operations';

final injectOperation = (String chain) => 'injection/operation?chain=$chain';

final balance = ({required String chain, required String level, required String address}) =>
    '${_levelPath(chain: chain, level: level)}/context/contracts/$address';

final managerKey = ({required String chain, required String level, required String address}) =>
    '${_levelPath(chain: chain, level: level)}/context/contracts/$address/manager_key';

final monitor = (String chain) => 'monitor/heads/$chain';
final operationHashes = ({
  required String chain,
  required String level,
  int? offset,
}) =>
    '${_levelPath(chain: chain, level: level)}/operation_hashes/${offset ?? ''}';

final constants =
    ({required String chain, required String level}) => '${_levelPath(chain: chain, level: level)}/context/constants';

final contract = ({
  required String chain,
  required String level,
  required String contractAddress,
}) =>
    '${_levelPath(chain: chain, level: level)}/context/contracts/$contractAddress';

final contractEntrypoints = ({
  required String chain,
  required String level,
  required String contractAddress,
}) =>
    '${contract(chain: chain, level: level, contractAddress: contractAddress)}/entrypoints';

final contractEntrypoint = ({
  required String chain,
  required String level,
  required String contractAddress,
  required String entrypoint,
}) =>
    '${contractEntrypoints(chain: chain, level: level, contractAddress: contractAddress)}/$entrypoint';

final pack = ({required String level, required String chain}) =>
    '${_levelPath(level: level, chain: chain)}/helpers/scripts/pack_data';

final bigMapValue = ({
  required String level,
  required String chain,
  required String id,
  required String encodedScriptExpression,
}) =>
    '${_levelPath(level: level, chain: chain)}/context/big_maps/$id/$encodedScriptExpression';

final _chainPath = (String chain) => 'chains/$chain';
final _levelPath = ({required String level, required String chain}) => '${_chainPath(chain)}/blocks/$level';
