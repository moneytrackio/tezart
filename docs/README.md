## Tezart

[![Dart env](https://img.shields.io/static/v1?label=License&message=MIT&color=blue)](https://github.com/moneytrackio/tezart/blob/main/LICENSE)
[![GitHub Actions](https://github.com/moneytrackio/tezart/workflows/Run%20tests/badge.svg)](https://github.com/moneytrackio/tezart/actions?query=workflow%3A%22Run+tests%22)
[![Coverage with codecov.io](https://codecov.io/gh/moneytrackio/tezart/branch/main/graph/badge.svg?token=0BOIGV5QCT)](https://codecov.io/gh/moneytrackio/tezart)



> A library for building decentralized applications in [dart language](https://dart.dev/)  currently focused on the [Tezos](http://tezos.com/) platform.

## What it is 

[Tezart](https://github.com/moneytrackio/tezart) connects to interact with the Tezos blockchain. It connects to a tezos node to send transactions, interact with smart contracts and much more !

See the [Quick start](quickstart.md) guide for more details.

## Features 

- [Tezos Chain Operations](tezos_chain_operations.md)
- [Smart Contract Interactions](smart_contract_interactions.md)

## Examples

Check out the [Showcase]() to see Tezart in use.

## Special Thanks

[Tezos foundation](https://tezos.foundation/) and [Moneytrack.io](http://moneytrack.io/) for the effort.
=======
> A library for building decentralized applications in [dart language](https://dart.dev/), currently focused on the [Tezos](http://tezos.com/) platform.

### What it is 

[Tezart](https://github.com/moneytrackio/tezart) connects to interact with the Tezos blockchain. It connects to a tezos node to send transactions, interact with smart contracts and much more !

See the [Quick start](#quick-start) guide for more details.

### Features 

- [Tezos Chain Operations](#tezos-chain-operations)
- [Smart Contract Interactions](#smart-contract-interactions)

### Examples

Check out the [Showcase]() to see Tezart in use.

### Special Thanks

[Tezos foundation](https://tezos.foundation/) and [Moneytrack.io](http://moneytrack.io/) for the effort.

## Quick start

### Use this package as a dart library 

1. Depend on it 

Add this to your package's pubspec.yaml file:

```dart
dependencies:
  tezart:
```

2. Install it

You can install packages from the command line:

with pub:

```sh 
$ dart pub get
```  

with Flutter: 

```sh 
$ flutter pub get
``` 

Alternatively, your editor might support dart pub get or flutter pub get. Check the docs for your editor to learn more.

3. Import it

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

```
docker run --rm \
    --name my-sandbox \
    --detach -p 20000:20000 \
    tqtezos/flextesa:20201214 delphibox start
```

#### C. Setup Lefthook

To install lefthook, just follow [this](https://github.com/Arkweid/lefthook/blob/master/docs/full_guide.md#installation) guide, then run :

```sh
lefthook install
```

#### Verify your setup 

To ensure that your environment is ready for contribution, please run the following command at the root of the project: 

```sh
./tezart doctor
```

You can add an alias like this `alias tezart='./tezart'` to avoid  calling the command line with `./`
 
Following is a sample of a correct setup :

<img src="img/a-sample-correct-setup.png?raw=true"></img>

### Utility functions

We provide some utility functions through `tezart` to help you in your development process. 

Following is the output usage : 

<img src="img/a-current-usage.png?raw=true"></img>


## Feature requests and bugs

If you want to contribute to this project, please [fork](https://github.com/moneytrackio/tezart) the project and submit your pull request. 

Submit your feature requests and bugs at the [issue tracker](https://github.com/moneytrackio/tezart/issues/new)

## Work in Progress

[wip - Classes à exporter](https://www.notion.so/Classes-exposer-fca03549f8ec4800a3ddf734ac0973d9)

## Other references

[API reference]()

[Changelog]()
