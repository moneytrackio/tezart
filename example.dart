import 'package:tezart/tezart.dart';

Future<void> main() async {
  //
  // Generate keystore from mnemonic
  //
  const mnemonic =
      'brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';
  var keystore = Keystore.fromMnemonic(mnemonic);

  print(keystore.secretKey);
  // => edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
  print(keystore.publicKey);
  // => edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
  print(keystore.address);
  // => tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW

  //
  // Generate keystore from secret key
  //
  const secretKey =
      'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';
  keystore = Keystore.fromSecretKey(secretKey);

  print(keystore.secretKey);
  // => edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
  print(keystore.publicKey);
  // => edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
  print(keystore.address);
  // => tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW

  //
  // Generate keystore from seed
  //
  const seed = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';
  keystore = Keystore.fromSeed(seed);

  print(keystore.secretKey);
  // => edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
  print(keystore.publicKey);
  // => edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
  print(keystore.address);
  // => tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW

  //
  // Transfer
  // In this example, we are using a wallet that has enough tez to make the transfer
  // We make the transfer and monitor the operation
  // All amounts are in µtz
  //
  final sourceKeystore = Keystore.fromSecretKey(
      'edskRpm2mUhvoUjHjXgMoDRxMKhtKfww1ixmWiHCWhHuMEEbGzdnz8Ks4vgarKDtxok7HmrEo1JzkXkdkvyw7Rtw6BNtSd7MJ7');
  final destinationKeystore = Keystore.random();
  final client = TezartClient('http://localhost:20000');
  final amount = 10000;

  final operationList = await client.transfer(
    source: sourceKeystore,
    destination: destinationKeystore.address,
    amount: amount,
  );
  await operationList.monitor();

  print(await client.getBalance(address: destinationKeystore.address));
  // => 10000
}
