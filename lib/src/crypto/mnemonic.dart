part of 'package:tezart/crypto.dart';

String generateMnemonic({int strength = 256}) =>
    bip39.generateMnemonic(strength: strength);
