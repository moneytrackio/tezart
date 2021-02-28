## Tezart

[![Dart env](https://img.shields.io/static/v1?label=License&message=MIT&color=blue)](https://github.com/moneytrackio/tezart/blob/main/LICENSE)
[![GitHub Actions](https://github.com/moneytrackio/tezart/workflows/Run%20tests/badge.svg)](https://github.com/moneytrackio/tezart/actions?query=workflow%3A%22Run+tests%22)
[![Coverage with codecov.io](https://codecov.io/gh/moneytrackio/tezart/branch/main/graph/badge.svg?token=0BOIGV5QCT)](https://codecov.io/gh/moneytrackio/tezart)



> A library for building decentralized applications in [dart language](https://dart.dev/), currently focused on the [Tezos](http://tezos.com/) platform.

### What it is 

[Tezart](https://github.com/moneytrackio/tezart) connects to interact with the Tezos blockchain. It connects to a tezos node to send transactions, interact with smart contracts and much more !

See the [Quick start](#quick-start) guide for more details.

### Features 

- [Tezos Chain Operations](#tezos-chain-operations)
- [Smart Contract Interactions](#smart-contract-interactions)

### Example

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
/// a tezos blockchain locally at http://localhost:2000
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
  final client = TezartClient(host: 'localhost', port: '20000', scheme: 'http');
  final amount = 10000;
  final operationId = await client.transfer(
    source: sourceKeystore,
    destination: destinationKeystore.address,
    amount: amount,
  );
  await client.monitorOperation(operationId);
  print(await client.getBalance(address: destinationKeystore.address));
  // => 10000
}
```

> Output : 

```bash
➜ dart example/example.dart
edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW
edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW
edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW
10000
```

### Special Thanks

[Tezos foundation](https://tezos.foundation/) and [Moneytrack.io](http://moneytrack.io/) for the effort.

## Quick start

### Use this package as a dart library 

1. **Depend on it** 

Add this to your package's pubspec.yaml file:

```dart
dependencies:
  tezart:
```

2. **Install it**

You can install packages from the command line:

with pub:

```bash 
dart pub get
```  

with Flutter: 

```bash 
flutter pub get
``` 

Alternatively, your editor might support dart pub get or flutter pub get. Check the docs for your editor to learn more.

3. **Import it**

Now in your Dart code, you can use:

```dart
import 'package:tezart/tezart.dart';
```

## API Overview and Examples

### Tezos Chain Operations

### Smart Contract Interactions

## Contribute


There are many ways to contribute to this project.
You can : 
- add some example into the `example folder`,
- contribute to the source code, 
- submit bug reports or feature requests,
- ask questions about it on [r/Tezos](http://reddit.com/r/tezos/) or the [Tezos StackExchange](https://tezos.stackexchange.com/). 

[Pull Requests are welcome as well !](#feature-requests-and-bugs)  

### Project versionning

We follow the semantic versioning from [semver](semver.org). Given a version number MAJOR.MINOR.PATCH, increment the:

- **MAJOR** version when you make incompatible API changes,
- **MINOR** version when you add functionality in a backwards compatible manner, and
- **PATCH** version when you make backwards compatible bug fixes. 

Read [dart package versioning](https://dart.dev/tools/pub/versioning) to learn more.

### Setup your development environment

**The following setup only work for Mac and Linux**

**Tezart** is a [dart](https://dart.dev/) package that will help your applications to interact with the tezos blockchain.

To ensure that you can contribute to this project, you will need to setup your environment with the installation of the following tools : 

- [dart sdk for package development](https://dart.dev/get-dart)
- [docker for local testing](https://docs.docker.com/get-docker/)
- [lefthook to our git hooks](https://github.com/Arkweid/lefthook)

#### A. Dart SDK for Package development

You can install **Dart SDK**, by following the [official dart documentation](https://dart.dev/get-dart)
#### B. Docker to run a tezos sandbox locally

1- If you don't have **Docker**, please install it by following the [official docker documentation](https://docs.docker.com/get-docker/)

2- If you have **Docker**, You will need a running blockchain on your local environment to launch the tests. You can use [tqtezos's sandbox](https://assets.tqtezos.com/docs/setup/2-sandbox/) by running the following command : 

```bash
docker run --rm \
    --name my-sandbox \
    --detach -p 20000:20000 \
    tqtezos/flextesa:20201214 delphibox start
```

#### C. Setup Lefthook

To install lefthook, just follow [this](https://github.com/Arkweid/lefthook/blob/master/docs/full_guide.md#installation) guide, then run :

```bash
lefthook install
```

#### Verify your setup 

To ensure that your environment is ready for contribution, please run the following command at the root of the project: 

```bash
./tezart doctor
```

You can add an alias like this `alias tezart='./tezart'` to avoid  calling the command line with `./`
 
Following is a sample of a correct setup :

<img src="img/a-sample-correct-setup.png?raw=true"></img>


### Edit this documentation

The following documentation is provided in `tezart/docs/` directory and you call the following command to serve it 
locally : 

```bash
./tezart docs
```

<img src="img/a-sample-tezart-docs.png?raw=true"></img>

### Utility functions

We provide some utility functions through `tezart` to help you in your development process. 

Following is the output usage : 

<img src="img/a-current-usage.png?raw=true"></img>


## Feature requests and bugs

If you want to contribute to this project, please [fork](https://github.com/moneytrackio/tezart) the project and submit your pull request. 

Submit your feature requests and bugs at the [issue tracker](https://github.com/moneytrackio/tezart/issues/new)