import 'package:tezart/src/crypto/crypto.dart';
import 'package:tezart/tezart.dart';

import 'base_validator.dart';

/// A validator that checks whether [str] is a valid hexadecimal
class HexValidator implements BaseValidator {
  final String str;

  HexValidator(this.str);

  /// Returns true if [str] is a valid hexadecimal
  @override
  bool get isValid => RegExp(r'^[a-fA-F0-9]+$').hasMatch(str);

  /// Throws [CryptoError] if [str] is not a valid hexadecimal
  @override
  void validate() {
    if (!isValid) throw CryptoError(type: CryptoErrorTypes.invalidHex);
  }
}
