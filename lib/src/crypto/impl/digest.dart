import 'package:blake2b/blake2b_hash.dart';
import 'package:meta/meta.dart';
import 'dart:typed_data';

Uint8List hashWithDigestSize({@required int size, Uint8List bytes}) => Blake2bHash.hashWithDigestSize(size, bytes);
