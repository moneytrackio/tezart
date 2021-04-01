// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$OperationToJson(Operation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kind', Operation._kindToString(instance.kind));
  writeNotNull('destination', instance.destination);
  writeNotNull('amount', Operation._toString(instance.amount));
  writeNotNull('balance', Operation._toString(instance.balance));
  writeNotNull('counter', Operation._toString(instance.counter));
  writeNotNull('parameters', instance.parameters);
  writeNotNull('script', instance.script);
  writeNotNull('gas_limit', Operation._toString(instance.gasLimit));
  writeNotNull('fee', Operation._toString(instance.fee));
  writeNotNull('storage_limit', Operation._toString(instance.storageLimit));
  writeNotNull('source', Operation._keystoreToAddress(instance.source));
  writeNotNull('public_key', instance.publicKey);
  return val;
}
