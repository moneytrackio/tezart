/// Library to create and retrieve keys to interact with the blockchain
library keystore;

import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

// internal Library 
import 'package:tezart/crypto.dart' as crypto;

// part implementation files
part 'src/keystore/keystore.dart';