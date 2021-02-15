import 'package:bip39/bip39.dart' as bip39;

String generateMnemonic({int strength = 256}) => bip39.generateMnemonic(strength: strength);
