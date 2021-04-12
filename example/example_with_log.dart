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
