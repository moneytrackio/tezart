import 'package:mockito/mockito.dart' as _i1;
import 'package:tezart/src/core/rpc/impl/rpc_interface.dart' as _i2;
import 'package:tezart/src/core/rpc/impl/tezart_http_client.dart' as _i3;

/// A class which mocks [RpcInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockRpcInterface extends _i1.Mock implements _i2.RpcInterface {
  MockRpcInterface() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [TezartHttpClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockTezartHttpClient extends _i1.Mock implements _i3.TezartHttpClient {
  MockTezartHttpClient() {
    _i1.throwOnMissingStub(this);
  }
}
