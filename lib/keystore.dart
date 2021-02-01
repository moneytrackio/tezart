/// Library to create and retrieve keys to interact with the blockchain
library keystore;

import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:equatable/equatable.dart';
import 'package:pinenacl/api.dart';

// internal Library 
import 'package:tezart/crypto.dart' as crypto;

// part implementation files
part 'src/keystore/keystore.dart';