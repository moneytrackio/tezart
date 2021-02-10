import 'package:test/test.dart';
import 'package:tezart/keystore.dart';
import 'package:tezart/src/tezart/rpc_interface/operation/operation.dart';
import 'package:tezart/src/utils/enum_util.dart';

void main() {
  const kind = Kinds.generic;
  final sourceKeystore = Keystore.fromSecretKey('edsk4CCa2afKwHWGxB5oZd4jvhq6tgd5EzFaryyR4vLdC3nvpjKUG6');
  final source = sourceKeystore.address;
  final publicKey = sourceKeystore.publicKey;
  const destination = 'tz1Q9L8us1DWMNDCyPcaScghH9fcgUSD1zFy';
  const amount = 1;
  const counter = 543;
  final parameters = {'first': 'parameter', 'second': 'parameter'};
  final fee = 1;
  final gasLimit = 10;
  final storageLimit = 100;

  group('#toJson()', () {
    test('returns valid Json when all fields are present', () {
      final operation = Operation(
          kind: kind,
          source: source,
          destination: destination,
          publicKey: publicKey,
          amount: amount,
          counter: counter,
          fee: fee,
          gasLimit: gasLimit,
          storageLimit: storageLimit,
          parameters: parameters);

      final expectedResult = {
        'kind': EnumUtil.enumToString(kind),
        'source': source,
        'public_key': publicKey,
        'destination': destination,
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
      final operation = Operation(
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
          kind: kind,
          source: source,
          destination: destination,
          counter: counter,
          fee: fee,
          gasLimit: gasLimit,
          storageLimit: storageLimit,
          parameters: parameters);

      expect(operation.toJson().keys, isNot(contains('amount')));
    });

    test('returns valid Json when parameters is missing', () {
      final operation = Operation(
          kind: kind,
          source: source,
          destination: destination,
          publicKey: publicKey,
          amount: amount,
          fee: fee,
          gasLimit: gasLimit,
          storageLimit: storageLimit,
          counter: counter);

      expect(operation.toJson().keys, isNot(contains('parameters')));
    });
  });

  group('.fromJson()', () {
    final subject = () => Operation.fromJson({
          'kind': EnumUtil.enumToString(kind),
          'source': source,
          'destination': destination,
          'public_key': publicKey,
          'amount': amount.toString(),
          'counter': counter.toString(),
          'fee': fee.toString(),
          'gas_limit': gasLimit.toString(),
          'storage_limit': storageLimit.toString(),
          'parameters': parameters
        });

    test('it sets all the fields correctly', () {
      final result = subject();

      expect(result.kind, equals(kind));
      expect(result.source, equals(source));
      expect(result.destination, equals(destination));
      expect(result.publicKey, equals(publicKey));
      expect(result.amount, equals(amount));
      expect(result.counter, equals(counter));
      expect(result.fee, equals(fee));
      expect(result.gasLimit, equals(gasLimit));
      expect(result.storageLimit, equals(storageLimit));
      expect(result.parameters, equals(parameters));
    });
  });
}
