import 'package:pointycastle/digests/blake2b.dart';
import 'package:meta/meta.dart';
import 'dart:typed_data';

Uint8List hashWithDigestSize({@required int size, Uint8List bytes}) =>
    Blake2bDigest(digestSize: size ~/ 8).process(bytes);
