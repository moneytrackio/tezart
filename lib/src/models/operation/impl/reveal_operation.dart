import 'package:tezart/tezart.dart';

import 'operation.dart';

class RevealOperation extends Operation {
  RevealOperation({
    int? customFee,
    int? gasLimit,
    int? storageLimit,
  }) : super(
          kind: Kinds.reveal,
          customFee: customFee,
          gasLimit: gasLimit,
          storageLimit: storageLimit,
        );
}
