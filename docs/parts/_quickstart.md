## Quick start

### Prerequisites

#### Install dart

You can install **Dart SDK**, by following the [official dart documentation](https://dart.dev/get-dart).

> *The minimal required version to use this package is 2.12*

#### Run a Tezos sandbox locally *(optional)*

> *You can skip this part if you want to use a public Tezos node.*

1- If you don't have **Docker**, please install it by following the [official docker documentation](https://docs.docker.com/get-docker/)

2- You can use [flextesa's sandbox](https://assets.tqtezos.com/docs/setup/2-sandbox/) by running the following command : 

> *Flextesa's sandbox is an ephemeral and isolated sandbox. It can be useful to experiment with faster networks or to automate reproducible tests.*

```bash
docker run --rm \
    --name my-sandbox \
    --detach -p 20000:20000 \
    tqtezos/flextesa:20210316 edobox start
```

### Use this package in a small dart app

1. Use `dart create` to create a command-line app:

```dart
dart create -t console-full tezart_example
```

2. Add tezart to your dependencies:

```yaml
dependencies:
  tezart: ^2.0.4
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
  final client = TezartClient('http://localhost:20000/');
  final amount = 10000;

  print('Starting transfer of $amount µtz from ${sourceKeystore.address} to ${destination} ...');
  final operationsList = await client.transferOperation(
    source: sourceKeystore,
    destination: destination,
    amount: amount,
  );
  await operationsList.execute();
  print('Transfer completed.');

  print('Monitoring the operation ...');
  await operationsList.monitor();
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
