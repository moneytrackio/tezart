import 'package:meta/meta.dart';

final pendingOperations = (String chain) => '${_chainPath(chain)}/mempool/pending_operations';
final branch = ({@required String chain, @required String level}) => '${_levelPath(chain: chain, level: level)}/hash';
final block = ({@required String chain, @required String level}) => _levelPath(level: level, chain: chain);
final chainId = (String chain) => '${_chainPath(chain)}/chain_id';

final counter = ({@required String chain, @required String level, @required String source}) =>
    '${_levelPath(chain: chain, level: level)}/context/contracts/$source/counter';

final protocol =
    ({@required String chain, @required String level}) => '${_levelPath(chain: chain, level: level)}/metadata';

final forgeOperations = ({@required String chain, @required String level}) =>
    '${_levelPath(chain: chain, level: level)}/helpers/forge/operations';

final runOperations = ({@required String chain, @required String level}) =>
    '${_levelPath(chain: chain, level: level)}/helpers/scripts/run_operation';

final injectOperation = (String chain) => 'injection/operation?chain=$chain';

final balance = ({@required String chain, @required String level, @required String address}) =>
    '${_levelPath(chain: chain, level: level)}/context/contracts/$address';

final managerKey = ({@required String chain, @required String level, @required String address}) =>
    '${_levelPath(chain: chain, level: level)}/context/contracts/$address/manager_key';

final monitor = (String chain) => 'monitor/heads/$chain';
final operationHashes = ({
  @required String chain,
  @required String level,
  int offset,
}) =>
    '${_levelPath(chain: chain, level: level)}/operation_hashes/${offset ?? ''}';

final constants =
    ({@required String chain, @required String level}) => '${_levelPath(chain: chain, level: level)}/context/constants';

final _chainPath = (String chain) => 'chains/$chain';
final _levelPath = ({@required String level, @required String chain}) => '${_chainPath(chain)}/blocks/$level';
