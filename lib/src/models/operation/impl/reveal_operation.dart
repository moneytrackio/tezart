import 'package:tezart/tezart.dart';

import 'operation.dart';

class RevealOperation extends Operation {
  RevealOperation({
    int? customFee,
    int? customGasLimit,
    int? customStorageLimit,
  }) : super(
          kind: Kinds.reveal,
          customFee: customFee,
          customGasLimit: customGasLimit,
          customStorageLimit: customStorageLimit,
        );
}
