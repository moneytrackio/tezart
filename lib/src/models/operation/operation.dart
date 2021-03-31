import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tezart/src/common/utils/enum_util.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operations_list/operations_list.dart';

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
  Map<String, dynamic> simulationResult;
  @JsonKey(ignore: true)
  OperationsList operationsList;
  @JsonKey(ignore: true)
  final log = Logger('Operation');

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

  Operation({
    @required this.kind,
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
  Keystore get source => operationsList.source;

  @JsonKey(name: 'public_key', nullable: true)
  String get publicKey => kind == Kinds.reveal ? source.publicKey : null;

  Map<String, dynamic> toJson() => _$OperationToJson(this);

  static String _toString(int integer) => integer == null ? null : integer.toString();
  static String _kindToString(Kinds kind) => EnumUtil.enumToString(kind);
  static String _keystoreToAddress(Keystore keystore) => keystore.address;
}
