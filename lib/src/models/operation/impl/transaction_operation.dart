import 'operation.dart';

class TransactionOperation extends Operation {
  TransactionOperation({
    required int amount,
    required String destination,
    Map<String, dynamic>? params,
    String? entrypoint,
    int? customFee,
  }) : super(
          kind: Kinds.transaction,
          destination: destination,
          params: params,
          amount: amount,
          entrypoint: entrypoint,
          customFee: customFee,
        );
}
