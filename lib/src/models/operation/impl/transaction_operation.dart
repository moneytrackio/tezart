import 'operation.dart';

class TransactionOperation extends Operation {
  TransactionOperation({
    required int amount,
    required String destination,
    Map<String, dynamic>? parameters,
    int? customFee,
  }) : super(
          kind: Kinds.transaction,
          destination: destination,
          parameters: parameters,
          amount: amount,
          customFee: customFee,
        );
}
