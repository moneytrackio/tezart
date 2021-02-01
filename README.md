# tezart

A dart library that connects to interact with the tezos blockchain. It connects to a tezos node to send transactions, interact with smart contracts.

## Features 

wip

## TODO 

wip 

## Usage

wip

## Contribution

### Run a tezos sandbox locally.
You can use: [tqtezos's sandbox](https://assets.tqtezos.com/docs/setup/2-sandbox/)

```
docker run --rm --name my-sandbox --detach -p 20000:20000 tqtezos/flextesa:20201214 delphibox start
```

### Setup Lefthook
Install lefthook following [this](https://github.com/Arkweid/lefthook/blob/master/docs/full_guide.md#installation) guide, then run :
```
lefthook install
```

### Setup env variables
```
cp .env.dist .env
```

### Run tests
```
./tool/run_tests.sh
```

## Feature requests and bugs 

If you want to contribute to this project, please fork the project and submit your pull request. Feature requests and bugs at the [issue tracker](https://github.com/moneytrackio/tezart/issues/new)
