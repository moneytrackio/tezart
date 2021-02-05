// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Operation _$OperationFromJson(Map<String, dynamic> json) {
  return Operation(
    kind: json['kind'] as String,
    source: json['source'] as String,
    destination: json['destination'] as String,
    amount: Operation._stringToInt(json['amount'] as String),
    counter: Operation._stringToInt(json['counter'] as String),
    gasLimit: Operation._stringToInt(json['gas_limit'] as String),
    fee: Operation._stringToInt(json['fee'] as String),
    storageLimit: Operation._stringToInt(json['storage_limit'] as String),
    publicKey: json['public_key'] as String,
    parameters: json['parameters'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$OperationToJson(Operation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kind', instance.kind);
  writeNotNull('source', instance.source);
  writeNotNull('destination', instance.destination);
  writeNotNull('public_key', instance.publicKey);
  writeNotNull('amount', Operation._intToString(instance.amount));
  writeNotNull('counter', Operation._intToString(instance.counter));
  writeNotNull('parameters', instance.parameters);
  writeNotNull('gas_limit', Operation._intToString(instance.gasLimit));
  writeNotNull('fee', Operation._intToString(instance.fee));
  writeNotNull('storage_limit', Operation._intToString(instance.storageLimit));
  return val;
}
