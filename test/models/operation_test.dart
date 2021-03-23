import 'package:test/test.dart';
import 'package:tezart/src/common/utils/enum_util.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/models/operation/operation.dart';
import 'package:tezart/tezart.dart';

void main() {
  final rpcInterface = RpcInterface('http://localhost:20000');
  const kind = Kinds.generic;
  final source = Keystore.fromSeed('edsk4CCa2afKwHWGxB5oZd4jvhq6tgd5EzFaryyR4vLdC3nvpjKUG6');
  final publicKey = source.publicKey;
  const destination = 'tz1Q9L8us1DWMNDCyPcaScghH9fcgUSD1zFy';
  const amount = 1;
  const balance = 1;
  const counter = 543;
  final parameters = {'first': 'parameter', 'second': 'parameter'};
  final fee = 1;
  final gasLimit = 10;
  final storageLimit = 100;

  group('#toJson()', () {
    test('returns valid Json when all fields are present', () {
      final operation = Operation(rpcInterface,
          kind: kind,
          source: source,
          destination: destination,
          publicKey: publicKey,
          balance: balance,
          amount: amount,
          counter: counter,
          fee: fee,
          gasLimit: gasLimit,
          storageLimit: storageLimit,
          parameters: parameters);

      final expectedResult = {
        'kind': EnumUtil.enumToString(kind),
        'source': source.address,
        'public_key': publicKey,
        'destination': destination,
        'balance': balance.toString(),
        'amount': amount.toString(),
        'counter': counter.toString(),
        'gas_limit': gasLimit.toString(),
        'fee': fee.toString(),
        'storage_limit': storageLimit.toString(),
        'parameters': parameters
      };

      expect(operation.toJson(), equals(expectedResult));
    });

    test('returns valid Json when publicKey is missing', () {
      final operation = Operation(rpcInterface,
          kind: kind,
          source: source,
          destination: destination,
          amount: amount,
          counter: counter,
          fee: fee,
          gasLimit: gasLimit,
          storageLimit: storageLimit,
          parameters: parameters);

      expect(operation.toJson().keys, isNot(contains('public_key')));
    });

    test('returns valid Json when amount is missing', () {
      final operation = Operation(
        rpcInterface,
        kind: kind,
        source: source,
        destination: destination,
        counter: counter,
        fee: fee,
        gasLimit: gasLimit,
        storageLimit: storageLimit,
        parameters: parameters,
      );

      expect(operation.toJson().keys, isNot(contains('amount')));
    });

    test('returns valid Json when parameters is missing', () {
      final operation = Operation(
        rpcInterface,
        kind: kind,
        source: source,
        destination: destination,
        publicKey: publicKey,
        amount: amount,
        fee: fee,
        gasLimit: gasLimit,
        storageLimit: storageLimit,
        counter: counter,
      );

      expect(operation.toJson().keys, isNot(contains('parameters')));
    });
  });
}
