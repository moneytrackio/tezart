### What it is

[Tezart](https://github.com/moneytrackio/tezart) is a [Dart](https://dart.dev/) library for building decentralized applications on [Tezos](https://tezos.com) blockchain.

Tezart interacts with a Tezos node to send transactions, interact with smart contracts and much more!

See the [Quick start](#quick-start) guide for more details.

### Special Thanks

[Tezos Foundation](https://tezos.foundation/) and [MoneyTrack](https://moneytrack.io/) for the effort.

### Example

1. [Install Dart](#install-dart) and [run a Tezos sandbox locally](#run-a-tezos-sandbox-locally-optional)
2. Clone the project:
```bash
git clone git@github.com:moneytrackio/tezart.git
```
3. run pub get:
```bash
cd tezart/
pub get
```
4. Execute the example:
```bash
dart tezart/example/example.dart
```

> tezart/example/example.dart

```dart
// Copyright (c), Moneytrack.io authors.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:tezart/tezart.dart';

// Sample mnemonic
const String mnemonic =
    'brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what';

// Sample secret key
const String secretKey =
    'edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap';

// Sample seed
const String seed = 'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';

///
/// This is a simple example of using tezart
/// In this example, we assume that you are running
/// a tezos blockchain locally at http://localhost:20000
///
/// In the README.md of the project, we provided a command line
/// to help you launch a local blockchain with docker.
///
Future<void> main() async {
  /// Generate keystore from mnemonic
  var keystore = Keystore.fromMnemonic(mnemonic);

  // Sample output of keystore created from mnemonic
  print(keystore.secretKey);
  // => edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
  print(keystore.publicKey);
  // => edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
  print(keystore.address);
  // => tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW

  /// Generate keystore from secret key
  keystore = Keystore.fromSecretKey(secretKey);

  // Sample output of keystore created from secretkey
  print(keystore.secretKey);
  // => edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
  print(keystore.publicKey);
  // => edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
  print(keystore.address);
  // => tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW

  /// Generate keystore from seed
  keystore = Keystore.fromSeed(seed);

  // Sample output of keystore created from seed
  print(keystore.secretKey);
  // => edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
  print(keystore.publicKey);
  // => edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
  print(keystore.address);
  // => tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW

  ///
  /// Transfer
  /// In this example, we are using a wallet that has enough tez to make the transfer
  /// We make the transfer and monitor the operation
  /// All amounts are in µtz
  ///
  final sourceKeystore = Keystore.fromSecretKey(
      'edskRpm2mUhvoUjHjXgMoDRxMKhtKfww1ixmWiHCWhHuMEEbGzdnz8Ks4vgarKDtxok7HmrEo1JzkXkdkvyw7Rtw6BNtSd7MJ7');
  final destinationKeystore = Keystore.random();
  final client = TezartClient('http://localhost:20000');
  final amount = 10000;
  final operationsList = await client.transferOperation(
    source: sourceKeystore,
    destination: destinationKeystore.address,
    amount: amount,
  );
  await operationsList.executeAndMonitor();
  print(await client.getBalance(address: destinationKeystore.address));
  // => 10000
}

```