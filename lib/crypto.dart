/// Exports low-level cryptographic operations needed to sign Tezos
/// transactions.
library crypto;

import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:meta/meta.dart';
import 'package:blake2b/blake2b_hash.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:collection/collection.dart';
import 'package:pinenacl/api.dart';

import 'src/crypto/exception.dart';

// part implementation files
part 'src/crypto/encode_decode.dart';
part 'src/crypto/digest.dart';
part 'src/crypto/mnemonic.dart';
part 'src/crypto/external_crypto_wrapper.dart';