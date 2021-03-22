import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tezart/src/common/utils/enum_util.dart';

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

// Transaction Operation
class TransactionOperation extends Operation {
  TransactionOperation({
    @required int amount,
    @required String source,
    @required String destination,
    @required int counter,
  }) : super(
          kind: Kinds.transaction,
          source: source,
          destination: destination,
          amount: amount,
          counter: counter,
        );
}

// Origination Operation
class OriginationOperation extends Operation {
  OriginationOperation({
    @required String source,
    @required int balance,
    @required int counter,
    @required List<Map<String, dynamic>> code,
    @required Map<String, dynamic> storage,
    int storageLimit,
  }) : super(
          kind: Kinds.origination,
          source: source,
          balance: balance,
          counter: counter,
          script: {
            'code': code,
            'storage': storage,
          },
          storageLimit: storageLimit,
        );
}

@JsonSerializable(includeIfNull: false)
class Operation {
  final String source;

  @JsonKey(toJson: _kindToString, fromJson: _stringToKind)
  final Kinds kind;

  @JsonKey(nullable: true)
  final String destination;

  @JsonKey(name: 'public_key', nullable: true)
  final String publicKey;

  @JsonKey(nullable: true, fromJson: _stringToInt, toJson: _toString)
  final int amount;

  @JsonKey(nullable: true, fromJson: _stringToInt, toJson: _toString)
  final int balance;

  @JsonKey(fromJson: _stringToInt, toJson: _toString)
  final int counter;

  @JsonKey(nullable: true)
  Map<String, dynamic> parameters;

  @JsonKey(nullable: true)
  Map<String, dynamic> script;

  @JsonKey(name: 'gas_limit', fromJson: _stringToInt, toJson: _toString)
  final int gasLimit;
  @JsonKey(fromJson: _stringToInt, toJson: _toString)
  final int fee;
  @JsonKey(name: 'storage_limit', fromJson: _stringToInt, toJson: _toString)
  final int storageLimit;

  Operation(
      {@required this.kind,
      @required this.source,
      @required this.counter,
      this.amount,
      this.balance,
      this.destination,
      this.publicKey,
      this.parameters,
      this.script,
      int gasLimit,
      int fee,
      int storageLimit})
      : gasLimit = gasLimit ?? defaultGasLimit[kind],
        fee = fee ?? defaultFee[kind],
        storageLimit = storageLimit ?? defaultStorageLimit[kind];

  factory Operation.fromJson(Map<String, dynamic> json) => _$OperationFromJson(json);

  Map<String, dynamic> toJson() => _$OperationToJson(this);

  static int _stringToInt(String string) => int.parse(string);
  static String _toString(int integer) => integer == null ? null : integer.toString();
  static String _kindToString(Kinds kind) => EnumUtil.enumToString(kind);
  static Kinds _stringToKind(String stringKind) => EnumUtil.stringToEnum(Kinds.values, stringKind);
}
