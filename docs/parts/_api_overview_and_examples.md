## API Overview and Examples

In the following examples we suppose that :

- the package `tezart` is imported correctly
- `client` is a `TezartClient` object defined with a running tezos node url
- `rpcInterface` is the `RpcInterface` of `client`
- `source` is a `Keystore` object defined using a revealed wallet and that has enough tez

```dart
import 'package:tezart/tezart.dart';

final source = Keystore.fromSeed('edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa');
final client = TezartClient('http://localhost:20000/');
final rpcInterface = client.rpcInterface;
```

### Enable logging

if you want this library to perform logging, you have to enable it :

```dart
enableTezartLogger();
```

### Tezos Chain Operations

#### Operation

`Operation` is the class that represents Tezos's single operation.

We implemented 3 types of operations:

- [`TransactionOperation`](https://pub.dev/documentation/tezart/latest/tezart/TransactionOperation-class.html): is the operation defined by the kind `transaction`. It is used to make transfers and smart contracts calls
- [`OriginationOperation`](https://pub.dev/documentation/tezart/latest/tezart/OriginationOperation-class.html): is the operation defined by the kind `origination`. It is used to originate smart contracts
- [`RevealOperation`](https://pub.dev/documentation/tezart/latest/tezart/RevealOperation-class.html): is the operation defined by the kind `reveal`. It is the first operation that need to be sent from a new address. This will reveal the public key associated to an address so that everyone can verify the signature for the operation and any future operations.

In order to inject an operation, you have to include it in an [OperationsList](#operationslist) object

#### OperationsList

`OperationsList` is the central class that allows you to execute, simulate, estimate and monitor a group of operations.

> The source of the operations is always stored in `OperationsList`, because the operations of the same group must have the same source in Tezos.

##### Add Operation objects

You can append and prepend an `Operation` using `appendOperation` and `prependOperation` methods

```dart
final operationsList = OperationsList(rpcInterface: rpcInterface, source: source);
final destination = Keystore.random();
final transactionOperation = TransactionOperation(amount: 100, destination: destination.address);

operationsList.appendOperation(transactionOperation);
```

##### Simulate

In order to simulate the execution of an `OperationsList` object you have to estimate its fees before:

```dart
await operationsList.estimate(); // computes the counters, storage limits, gas limits and fees
await operationsList.simulate(); // will throw an error if anything wrong happens
```

##### Execute

You can inject an `OperationsList` using the `execute` method. It will estimate, simulate and inject the operation group in the chain.

```dart
await operationsList.execute();
```

##### Monitor

You can monitor an injected `OperationsList` using the `monitor` method. It will wait for the operation to be included in a block

```dart
await operationsList.execute();
await operationsList.monitor(); // <=> await operationsList.executeAndMonitor()
```

#### TezartClient

`TezartClient` implements some helper methods that construct the `OperationsList` object for you:

- `transferOperation` : returns an `OperationsList` containing a `TransactionOperation` and a `RevealOperation` if the source is not revealed (this behaviour can be disabled by setting `reveal` named parameter to `false`)
- `revealKeyOperation` : returns an `OperationsList` containing a `RevealOperation`
- `originateContractOperation` : returns an `OperationsList` containing an `OriginationOperation` (including the auto reveal behaviour described in `transferOperation`)

```dart
final destination = Keystore.random();

final operationsList = await client.transferOperation({
    source: source,
    destination: desination,
    amount: 10,
    reveal: true,
});
```

#### Contract

##### Origination

In order to generate an `OperationsList` that makes a contract origination, you have to:

- originate the contract `OperationsList` using `originateContractOperation`'s `TezartClient` method
- `executeAndMonitor` the `OperationsList` object
- retrieve the originated contract's address using the `OriginationOperation`'s `contractAddress` method

```dart
final code = [ { 'prim': 'storage', 'args': [ {'prim': 'nat'} ] }, { 'prim': 'parameter', 'args': [ { 'prim': 'or', 'args': [ { 'prim': 'nat', 'annots': ['%divide'] }, { 'prim': 'or', 'args': [ { 'prim': 'unit', 'annots': ['%double'] }, { 'prim': 'nat', 'annots': ['%replace'] } ] } ] } ] }, { 'prim': 'code', 'args': [ [ {'prim': 'UNPAIR'}, { 'prim': 'IF_LEFT', 'args': [ [ {'prim': 'DUP'}, { 'prim': 'PUSH', 'args': [ {'prim': 'nat'}, {'int': '5'} ] }, {'prim': 'COMPARE'}, {'prim': 'LT'}, { 'prim': 'IF', 'args': [ [], [ { 'prim': 'PUSH', 'args': [ {'prim': 'string'}, {'string': 'WrongCondition: params.divisor > 5'} ] }, {'prim': 'FAILWITH'} ] ] }, {'prim': 'SWAP'}, {'prim': 'EDIV'}, { 'prim': 'IF_NONE', 'args': [ [ { 'prim': 'PUSH', 'args': [ {'prim': 'int'}, {'int': '20'} ] }, {'prim': 'FAILWITH'} ], [ {'prim': 'CAR'} ] ] } ], [ { 'prim': 'IF_LEFT', 'args': [ [ {'prim': 'DROP'}, { 'prim': 'PUSH', 'args': [ {'prim': 'nat'}, {'int': '2'} ] }, {'prim': 'MUL'} ], [ {'prim': 'SWAP'}, {'prim': 'DROP'} ] ] } ] ] }, { 'prim': 'NIL', 'args': [ {'prim': 'operation'} ] }, {'prim': 'PAIR'} ] ] } ];
final storage = {'int' : '12'};

final originationOperationsList = await client.originateContractOperation(
    source: source,
    code: code,
    storage: storage,
    balance: 10,
);
await originationOperationsList.executeAndMonitor();
final originationOperation = originationOperationsList.operations.firstWhere((operation) => operation is OriginationOperation);
final contractAddress = originationOperation.contractAddress;
```

##### Call

In order to make a contract call to an entrypoint, you have to:

- construct a `Contract` object using the contract address
- use `callOperation`'s `Contract` method to generate the `OperationsList` object
- `executeAndMonitor` the `OperationsList` object

```dart
final contract = Contract(contractAddress: contractAddress, rpcInterface: rpcInterface);
final callContractOperationsList = await contract.callOperation(
    entrypoint: 'divide',
    params: 42,
    source: source,
);
await callContractOperationsList.executeAndMonitor();
```

##### Storage

You can fetch the storage of a contract using `storage` getter of `Contract` class. The storage is converted from Micheline to Dart basic objects.

```dart
final contract = Contract(contractAddress: contractAddress, rpcInterface: rpcInteface);
await contract.storage;
```

##### Introspection

You can fetch the list of the entrypoints of a contract using `entrypoints` getter.

```dart
final contract = Contract(contractAddress: contractAddress, rpcInterface: rpcInterface);
await contract.entrypoints;
```

If you want the types in Micheline of these entrypoints you can use `getContractEntrypoints`'s `RpcInterface`. This will return a `Map` that maps the entrypoints names to its types in Micheline.

```dart
await rpcInterface.getContractEntrypoints(contractAddress);
```