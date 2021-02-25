import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tezart/src/common/validators/hex_validator.dart';
import 'package:tezart/src/keystore/keystore.dart';

import 'package:tezart/src/crypto/crypto.dart' as crypto;

enum Watermarks {
  block,
  endorsement,
  generic,
}

@immutable
class Signature extends Equatable {
  final Uint8List bytes;
  final Keystore keystore;
  final Watermarks watermark;

  static final _watermarkToHex = {
    Watermarks.block: '01',
    Watermarks.endorsement: '02',
    Watermarks.generic: '03',
  };

  Signature._({@required this.bytes, @required this.keystore, this.watermark});

  factory Signature.fromBytes({@required Uint8List bytes, @required Keystore keystore, Watermarks watermark}) {
    return Signature._(bytes: bytes, watermark: watermark, keystore: keystore);
  }

  factory Signature.fromHex({@required String data, @required Keystore keystore, Watermarks watermark}) {
    return crypto.catchUnhandledErrors(() {
      HexValidator(data).validate();
      // Because two hexadecimal digits correspond to a single byte, this will throw an error if the length of the data is odd
      if (data.length.isOdd) throw crypto.CryptoError(type: crypto.CryptoErrorTypes.invalidHexDataLength);
      var bytes = crypto.hexDecode(data);

      return Signature.fromBytes(bytes: bytes, keystore: keystore, watermark: watermark);
    });
  }

  Uint8List get signedBytes {
    return crypto.catchUnhandledErrors(() {
      final watermarkedBytes =
          watermark == null ? bytes : Uint8List.fromList(crypto.hexDecode(_watermarkToHex[watermark]) + bytes);
      var hashedBytes = crypto.hashWithDigestSize(size: 256, bytes: watermarkedBytes);
      var secretKey = keystore.secretKey;
      var secretKeyBytes = crypto.decodeWithoutPrefix(secretKey);

      return crypto.signDetached(bytes: hashedBytes, secretKey: secretKeyBytes);
    });
  }

  String get edsig {
    return crypto.catchUnhandledErrors(() {
      return crypto.encodeWithPrefix(prefix: crypto.Prefixes.edsig, bytes: signedBytes);
    });
  }

  String get hexIncludingPayload {
    return crypto.catchUnhandledErrors(() {
      return crypto.hexEncode(Uint8List.fromList(bytes + signedBytes));
    });
  }

  @override
  List<Object> get props => [signedBytes];
}
