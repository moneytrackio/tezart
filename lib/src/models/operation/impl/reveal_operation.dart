import 'package:tezart/tezart.dart';

import 'operation.dart';

class RevealOperation extends Operation {
  RevealOperation()
      : super(
          kind: Kinds.reveal,
          customFee: 0,
        );
}
