import 'operation.dart';

const defaultGasLimit = {
  Kinds.delegation: 10600,
  Kinds.origination: 10600,
  Kinds.transfer: 10600,
  Kinds.reveal: 10600,
  Kinds.transaction: 10600, // TODO: remove this line because it must be computed via a dry run call
};

const defaultFee = {
  Kinds.delegation: 1257,
  Kinds.origination: 10000,
  Kinds.transfer: 10000,
  Kinds.reveal: 1420,
  Kinds.transaction: 1350 // TODO: remove this line because it must be computed via a dry run call
};

const defaultStorageLimit = {
  Kinds.delegation: 0,
  Kinds.origination: 257,
  Kinds.transfer: 257,
  Kinds.reveal: 0,
  Kinds.transaction: 277 // TODO: remove this line because it must be computed via a dry run call
};