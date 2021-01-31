/// Library to create and retrieve keys to interact with the blockchain
library keystore;

import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:equatable/equatable.dart';

// internal Library
import 'src/crypto/crypto_operation.dart';

// part implementation files
part 'src/keystore/keystore.dart';
