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
/// a tezos RPC API locally at http://localhost:20000
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

### Special Thanks

[Tezos foundation](https://tezos.foundation/) and [Moneytrack.io](http://moneytrack.io/) for the effort.

## Quick start

### Prerequisites

#### Install dart

You can install **Dart SDK**, by following the [official dart documentation](https://dart.dev/get-dart)

#### Run a Tezos sandbox locally *(optional)*

> *You can skip this part if you want to use a public Tezos node.*

1- If you don't have **Docker**, please install it by following the [official docker documentation](https://docs.docker.com/get-docker/)

2- You can use [flextesa's sandbox](https://assets.tqtezos.com/docs/setup/2-sandbox/) by running the following command : 

> *Flextesa's sandbox is an ephemeral and isolated sandbox. It can be useful to experiment with faster networks or to automate reproducible tests.*

```bash
docker run --rm \
    --name my-sandbox \
    --detach -p 20000:20000 \
    tqtezos/flextesa:20201214 delphibox start
```

### Use this package in a small dart app

1. Use `dart create` to create a command-line app:

```dart
dart create -t console-full tezart_example
```

2. Add tezart to your dependencies:

```yaml
dependencies:
  tezart:
```

```bash
cd tezart_example
pub get
```

3. Change `lib/tezart_example.dart` to :

```dart
import 'package:tezart/tezart.dart';

Future<void> main() async {
  const String secretKey = 'edskRpm2mUhvoUjHjXgMoDRxMKhtKfww1ixmWiHCWhHuMEEbGzdnz8Ks4vgarKDtxok7HmrEo1JzkXkdkvyw7Rtw6BNtSd7MJ7';
  final sourceKeystore = Keystore.fromSecretKey(secretKey);
  final destination = Keystore.random().address;
  final client = TezartClient(host: 'localhost', port: '20000', scheme: 'http');
  final amount = 10000;

  print('Starting transfer of $amount µtz from ${sourceKeystore.address} to ${destination} ...');
  final operationId = await client.transfer(
    source: sourceKeystore,
    destination: destination,
    amount: amount,
  );
  print('Transfer completed.');
  print('Monitoring the operation ...');
  await client.monitorOperation(operationId);
  print('Monitoring completed.');
}

```

4. Change `bin/tezart_example.dart` to :

```dart
import 'package:tezart_example/tezart_example.dart' as tezart_example;

void main(List<String> arguments) async {
  await tezart_example.main();
}
```

5. Run the app :

```bash
dart run
```

> Output

<img src="img/quick-start-example-output.gif?raw=true"></img>


## API Overview and Examples

### Enable logging

if you want this library to perform logging, you have to enable it :

> tezart/example/example_with_log.dart

```dart
// Copyright (c), Moneytrack.io authors.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:tezart/tezart.dart';

///
/// This is a simple example of using tezart
/// In this example, we assume that you are running
/// a tezos blockchain locally at http://localhost:20000
///
/// In the README.md of the project, we provided a command line
/// to help you launch a local blockchain with docker.
///
Future<void> main() async {
  ///
  /// Enable the log (Optional)
  ///
  enableTezartLogger();

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

<img src="img/a-output-example-log-dart.png?raw=true"></img>

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

The versioning scheme we use is [SemVer](http://semver.org/). Given a version number MAJOR.MINOR.PATCH, increment the:

- **MAJOR** version when you make incompatible API changes,
- **MINOR** version when you add functionality in a backwards compatible manner, and
- **PATCH** version when you make backwards compatible bug fixes. 

Read [dart package versioning](https://dart.dev/tools/pub/versioning) to learn more.

### Setup your development environment

> *The following setup only works for Mac and Linux*

To ensure that you can contribute to this project, you will need to setup your environment :

#### A. Install prerequisites
You can follow the instructions in the prerequisites [section](#prerequisites)

#### B. Setup Lefthook

To install lefthook, just follow [this](https://github.com/Arkweid/lefthook/blob/master/docs/full_guide.md#installation) guide, then run :

```bash
lefthook install
```

#### C. Verify your setup 

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

### Pull Request advice

- Ensure to have a correct output for `tezart doctor` in your development environment. 
- Update the `docs/README.md` if necessary with details of changes that you've made. This includes new API,
   useful command-line option, etc...
- You may merge the Pull Request in once you have the sign-off of two other developers, or if you 
   do not have permission to do that, you may request the second reviewer to merge it for you.