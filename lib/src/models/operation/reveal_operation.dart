import 'operation.dart';

class RevealOperation extends Operation {
  RevealOperation({int storageLimit})
      : super(
          kind: Kinds.reveal,
        );
}
