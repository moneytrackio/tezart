import 'package:tezart/src/crypto/crypto.dart';
import 'package:tezart/tezart.dart';

import 'base_validator.dart';

class HexValidator implements BaseValidator {
  final String str;

  HexValidator(this.str);

  @override
  bool get isValid => RegExp(r'^[a-fA-F0-9]+$').hasMatch(str);

  @override
  void validate() {
    if (!isValid) throw CryptoError(type: CryptoErrorTypes.invalidHex);
  }
}
