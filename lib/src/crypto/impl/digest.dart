import 'package:pointycastle/digests/blake2b.dart';
import 'dart:typed_data';

Uint8List hashWithDigestSize({required int size, required Uint8List bytes}) =>
    Blake2bDigest(digestSize: size ~/ 8).process(bytes);
