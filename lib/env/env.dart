import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify(path: '.env.tests')
abstract class Env {
  static const tezosNodeHost = _Env.tezosNodeHost;
  static const tezosNodePort = _Env.tezosNodePort;
  static const tezosNodeScheme = _Env.tezosNodeScheme;
}
