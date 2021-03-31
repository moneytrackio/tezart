import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tezart/src/common/utils/enum_util.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operation/operation_result.dart';
import 'package:tezart/src/models/operation_list/operation_list.dart';

import 'constants.dart';

part 'operation.g.dart';

enum Kinds {
  generic,
  transaction,
  delegation,
  origination,
  transfer,
  reveal,
}

@JsonSerializable(includeIfNull: false, createFactory: false)
class Operation {
  @JsonKey(ignore: true)
  final operationResult = OperationResult();
  @JsonKey(ignore: true)
  OperationList operationList;
  @JsonKey(ignore: true)
  final log = Logger('Operation');
  @JsonKey(ignore: true)
  final RpcInterface rpcInterface;

  @JsonKey(toJson: _kindToString)
  final Kinds kind;

  @JsonKey(nullable: true)
  final String destination;

  @JsonKey(nullable: true, toJson: _toString)
  final int amount;

  @JsonKey(nullable: true, toJson: _toString)
  final int balance;

  @JsonKey(toJson: _toString)
  int counter;

  @JsonKey(nullable: true)
  Map<String, dynamic> parameters;

  @JsonKey(nullable: true)
  Map<String, dynamic> script;

  @JsonKey(name: 'gas_limit', toJson: _toString)
  final int gasLimit;
  @JsonKey(toJson: _toString)
  final int fee;
  @JsonKey(name: 'storage_limit', toJson: _toString)
  final int storageLimit;

  Operation(
    this.rpcInterface, {
    @required this.kind,
    @required this.counter,
    this.amount,
    this.balance,
    this.destination,
    this.parameters,
    this.script,
    int gasLimit,
    int fee,
    int storageLimit,
  })  : gasLimit = gasLimit ?? defaultGasLimit[kind],
        fee = fee ?? defaultFee[kind],
        storageLimit = storageLimit ?? defaultStorageLimit[kind];

  @JsonKey(toJson: _keystoreToAddress)
  Keystore get source => operationList.source;

  @JsonKey(name: 'public_key', nullable: true)
  String get publicKey => kind == Kinds.reveal ? source.publicKey : null;

  Map<String, dynamic> toJson() => _$OperationToJson(this);

  static String _toString(int integer) => integer == null ? null : integer.toString();
  static String _kindToString(Kinds kind) => EnumUtil.enumToString(kind);
  static String _keystoreToAddress(Keystore keystore) => keystore.address;
}
