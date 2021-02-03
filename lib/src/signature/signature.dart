import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:tezart/keystore.dart';
import 'package:tezart/crypto.dart' as crypto;

@immutable
class Signature extends Equatable {
  final Uint8List bytes;
  final KeyStore keyStore;
  final String watermark;

  static final _watermarkValue = {
    'block': '01',
    'endorsement': '02',
    'generic': '03'
  };

  Signature._({ @required this.bytes,
                @required this.keyStore,
                this.watermark });

  factory Signature.fromBytes({ @required Uint8List bytes,
                                @required KeyStore keyStore,
                                String watermark }) {
    return Signature._(bytes: bytes,
                       watermark: watermark,
                       keyStore: keyStore);
  }

  factory Signature.fromHex({ @required String data, @required KeyStore keyStore, String watermark }) {
    var bytes = crypto.hexDecode(data);

    return Signature.fromBytes(bytes: bytes, keyStore: keyStore, watermark: watermark);
  }

  Uint8List get signedBytes {
    final watermarkedBytes = watermark == null ? bytes :
      Uint8List.fromList(crypto.hexDecode(_watermarkValue[watermark]) + bytes);
    var hashedBytes = crypto.hashWithDigestSize(size: 256, bytes: watermarkedBytes);
    var edskSecretKey = keyStore.edsk;
    var sk = crypto.decodeTz(edskSecretKey);

    return crypto.signDetached(bytes: hashedBytes, secretKey: sk);
  }

  String get edsig {
    return crypto.encodeTz(prefix: 'edsig', bytes: signedBytes);
  }

  String get hex {
    return crypto.hexEncode(Uint8List.fromList(bytes + signedBytes));
  }

  @override
  List<Object> get props => [signedBytes];
}
