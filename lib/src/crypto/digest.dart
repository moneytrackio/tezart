part of 'package:tezart/crypto.dart';

Uint8List hashWithDigestSize({@required int size, Uint8List bytes}) =>
    Blake2bHash.hashWithDigestSize(size, bytes);
