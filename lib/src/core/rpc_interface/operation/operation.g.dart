// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Operation _$OperationFromJson(Map<String, dynamic> json) {
  return Operation(
    kind: Operation._stringToKind(json['kind'] as String),
    source: json['source'] as String,
    counter: Operation._stringToInt(json['counter'] as String),
    amount: Operation._stringToInt(json['amount'] as String),
    destination: json['destination'] as String,
    publicKey: json['public_key'] as String,
    parameters: json['parameters'] as Map<String, dynamic>,
    gasLimit: Operation._stringToInt(json['gas_limit'] as String),
    fee: Operation._stringToInt(json['fee'] as String),
    storageLimit: Operation._stringToInt(json['storage_limit'] as String),
  );
}

Map<String, dynamic> _$OperationToJson(Operation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('source', instance.source);
  writeNotNull('kind', Operation._kindToString(instance.kind));
  writeNotNull('destination', instance.destination);
  writeNotNull('public_key', instance.publicKey);
  writeNotNull('amount', Operation._toString(instance.amount));
  writeNotNull('counter', Operation._toString(instance.counter));
  writeNotNull('parameters', instance.parameters);
  writeNotNull('gas_limit', Operation._toString(instance.gasLimit));
  writeNotNull('fee', Operation._toString(instance.fee));
  writeNotNull('storage_limit', Operation._toString(instance.storageLimit));
  return val;
}
