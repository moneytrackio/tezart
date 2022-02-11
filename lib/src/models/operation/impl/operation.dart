import 'package:logging/logging.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tezart/src/common/utils/enum_util.dart';
import 'package:tezart/src/common/validators/simulation_result_validator.dart';
import 'package:tezart/src/keystore/keystore.dart';
import 'package:tezart/src/models/operation/impl/operation_visitor.dart';
import 'package:tezart/src/models/operations_list/operations_list.dart';
import 'package:tezart/tezart.dart';

part 'operation.g.dart';

enum Kinds {
  generic,
  transaction,
  delegation,
  origination,
  transfer,
  reveal,
}

/// A class representing a single tezos operation
@JsonSerializable(includeIfNull: false, createFactory: false)
class Operation {
  @JsonKey(ignore: true)
  Map<String, dynamic>? _simulationResult;
  @JsonKey(ignore: true)
  OperationsList? operationsList;
  @JsonKey(ignore: true)
  final log = Logger('Operation');

  @JsonKey(toJson: _kindToString)
  final Kinds kind;

  @JsonKey()
  final String? destination;

  @JsonKey(toJson: _toString)
  final int? amount;

  @JsonKey(toJson: _toString)
  final int? balance;

  @JsonKey(toJson: _toString)
  int? counter;

  @JsonKey(ignore: true)
  Map<String, dynamic>? params;

  @JsonKey(ignore: true)
  String? entrypoint;

  @JsonKey()
  Map<String, dynamic>? script;

  @JsonKey(name: 'gas_limit', toJson: _toString)
  int? gasLimit;
  @JsonKey(toJson: _toString)
  int fee;
  @JsonKey(ignore: true)
  final int? customFee;
  @JsonKey(name: 'storage_limit', toJson: _toString)
  int? storageLimit;
  @JsonKey(ignore: true)
  int? customGasLimit;
  @JsonKey(ignore: true)
  int? customStorageLimit;

  Operation({
    required this.kind,
    this.amount,
    this.balance,
    this.destination,
    this.params,
    this.script,
    this.customFee,
    this.entrypoint,
    this.customGasLimit,
    this.customStorageLimit,
  }) : fee = 0;

  @JsonKey(toJson: _keystoreToAddress)
  Keystore get source {
    if (operationsList == null) throw ArgumentError.notNull('operationsList');

    return operationsList!.source;
  }

  @JsonKey()
  Map<String, dynamic>? get parameters {
    var result = <String, dynamic>{};
    if (params != null) {
      if (params!.containsKey('entrypoint')) {
        result = params!;
      } else {
        if (entrypoint != null) {
          result['entrypoint'] = entrypoint;
          result['value'] = params;
        }
      }
    }

    return result.keys.isEmpty ? null : result;
  }

  @JsonKey(name: 'public_key')
  String? get publicKey => kind == Kinds.reveal ? source.publicKey : null;

  Map<String, dynamic> toJson() => _$OperationToJson(this);

  static String? _toString(int? integer) =>
      integer == null ? null : integer.toString();
  static String _kindToString(Kinds kind) => EnumUtil.enumToString(kind);
  static String _keystoreToAddress(Keystore keystore) => keystore.address;

  set simulationResult(Map<String, dynamic>? value) {
    if (value == null) throw ArgumentError.notNull('simulationResult');

    _simulationResult = value;
    SimulationResultValidator(_simulationResult!).validate();
  }

  @JsonKey(ignore: true)
  Map<String, dynamic>? get simulationResult => _simulationResult;

  Future<void> setLimits(OperationVisitor visitor) async {
    await visitor.visit(this);
  }
}
