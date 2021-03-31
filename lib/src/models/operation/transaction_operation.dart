import 'package:meta/meta.dart';
import 'package:tezart/src/models/operations_list/operations_list.dart';

import 'operation.dart';

class TransactionOperation extends Operation {
  TransactionOperation({
    @required OperationsList operationsList,
    @required int amount,
    @required String destination,
  }) : super(
          kind: Kinds.transaction,
          destination: destination,
          amount: amount,
        );
}
