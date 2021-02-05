import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation.g.dart';

@JsonSerializable(includeIfNull: false)
class Operation {
  final String kind, source, destination;

  @JsonKey(name: 'public_key', nullable: true)
  final String publicKey;

  @JsonKey(fromJson: _stringToInt, toJson: _intToString)
  final int amount;

  @JsonKey(fromJson: _stringToInt, toJson: _intToString)
  final int counter;

  @JsonKey(nullable: true)
  Map<String, dynamic> parameters;

  @JsonKey(name: 'gas_limit', fromJson: _stringToInt, toJson: _intToString)
  final int gasLimit;
  @JsonKey(fromJson: _stringToInt, toJson: _intToString)
  final int fee;
  @JsonKey(name: 'storage_limit', fromJson: _stringToInt, toJson: _intToString)
  final int storageLimit;

  Operation({ @required this.kind,
              @required this.source,
              @required this.destination,
              @required this.amount,
              @required this.counter,
              @required this.gasLimit,
              @required this.fee,
              @required this.storageLimit,
              this.publicKey,
              this.parameters });

  factory Operation.fromJson(Map<String, dynamic> json) => _$OperationFromJson(json);

  Map<String, dynamic> toJson() => _$OperationToJson(this);

  static int _stringToInt(String string) => int.parse(string);
  static String _intToString(int integer) => integer.toString();
}