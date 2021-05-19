import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart';
import 'package:tezart/src/crypto/crypto.dart';
import 'package:tezart/src/micheline_decoder/micheline_decoder.dart';
import 'package:tezart/src/micheline_encoder/micheline_encoder.dart';

/// A class that allows big maps values fetching
///
/// - [name] is the name of this if it is annotated
/// - [id] the id of this
/// - [valueType] the value type of this in Micheline
/// - [keyType] the key type of this in Micheline
class BigMap {
  final String? name;
  final String id;
  final Map<String, dynamic> valueType, keyType;

  BigMap({
    required this.name,
    required this.id,
    required this.valueType,
    required this.keyType,
  });

  /// Fetches [key] from this using [rpcInterface]
  ///
  /// if the key is not found a [TezartHttpError] is thrown
  /// - [key] is supposed to be a Dart Type. It will be converted using [MichelineEncoder]
  Future<dynamic> fetch({required dynamic key, required RpcInterface rpcInterface}) async {
    final michelineKey = MichelineEncoder(type: keyType, params: key).encode();
    final encodedScriptExpression = await _encodedScriptExpression(
      decodedKey: michelineKey,
      rpcInterface: rpcInterface,
    );

    final michelineValue = await rpcInterface.bigMapValue(id: id, encodedScriptExpression: encodedScriptExpression);

    return MichelineDecoder(type: valueType, data: michelineValue).decode();
  }

  Future<String> _encodedScriptExpression({dynamic decodedKey, required RpcInterface rpcInterface}) async {
    final packedKey = await rpcInterface.pack(data: decodedKey, type: keyType);
    final bytesKey = Uint8List.fromList(hex.decode(packedKey));
    final hashKey = hashWithDigestSize(size: 256, bytes: bytesKey);

    return encodeWithPrefix(prefix: Prefixes.expr, bytes: hashKey);
  }
}
